
`timescale 1ns / 1ps

/**************************************
	PIPELINED MULTICYCLE PROCESSOR
**************************************/

module MCP
	(
		input   clk,rst
	);

	//wires:
	wire [31:0] PC_Control_pipe, PC, PC_pipe, PC_pipe_2, PC_pipe_3, PC_pipe_4,  PC_Control, pc_rd,PC_In,
				Instruction, Instruction_pipe,New_Instruction,
				Imm, Imm_pipe,
				BUS_Forward_A,BUS_Forward_B,BUS_Forward_B_pipe,
				TwoCycle,
				A_data, B_data, A_data_pipe, B_data_pipe, BUS_A, BUS_B, BUS_D, BUS_B_pipe,BUS_B_lw,
				FU_out, FU_out_pipe, FU_out_pipe_2, FU_out_pipe_3,
				Data_in, Data_in_pipe, Data_in_wire;
	
	wire [31:0] PC_to_IM;
	
	wire [31:0] PC_minus_four = PC - 32'd4;			
	
	wire [4:0]  AA, BA, DA, 
				EXMEM_DA, IDEX_AA, IDEX_BA, IDEX_DA,MEMWB_DA,EXMEM_BA,IFID_DA;
	
	wire [3:0] 	FS, FS_pipe;
	
	wire 		RW, MB, MW, MA, PL, JB,
				PL_pipe, JB_pipe,
				IFID_RW, IDEX_RW, EXMEM_RW, MEMWB_RW, 
				MA_pipe, MB_pipe, MW_pipe, MW_pipe_2,
				V, C, Z, N,
				pc_c, LwSw_sel, LUHazard,
				load_disable_in, load_disable_in_pipe, load_disable_in_pipe_2;
	
	wire [1:0] 	BC, MD, MEM_CONT,  MD_pipe, MD_pipe_2, MD_pipe_3, BC_pipe, MEM_CONT_pipe,MEM_CONT_pipe_2,Forward_A,Forward_B ;
	wire [2:0] 	im_sel, data_sel, data_sel_pipe, data_sel_pipe_2;

	reg 		load_disable_in_pipe_3;
	
	
	/**********************
	ONE PIPE FOR FLUSH OPS
	**********************/
	
	always@(posedge clk)
	begin
		if(rst)
		begin
			load_disable_in_pipe_3 <= 1'b0;
		end
		else
		begin
			load_disable_in_pipe_3 <= load_disable_in_pipe_2;
		end
	end
	


	wire write_disable = load_disable_in_pipe_2  || load_disable_in_pipe_3; 
	
	/**********************
	ONE PIPE FOR FLUSH OPS
	**********************/
	
	// FETCH PART 
	
	 MUX2 #(32) MUXS
	 (
	 .C0		(PC_Control), 
	 .C1		(PC),
	 .S			(LUHazard),
	 .O			(PC_In)
	 );
	
	 
	PC Program_Counter
	(
	.PC_new	(PC_In), 
	.clk	(clk), 
	.rst	(rst), 
	.PC		(PC)
	);
	


	
	MUX2 #(32) 
	MUXselect
	(
	.C0		(PC),
	.C1		(PC_minus_four),
	.S		(LUHazard),
	.O		(PC_to_IM)
	);
	
	Instruction_Memory  
	#(
	.ADDR_WIDTH	(10),
	.DATA_WIDTH	(32)
	) 
	INST_MEM
	(
	.Address_out	(PC_to_IM),
	.inst_out		(Instruction)
	);
	
	//IF-ID PIPE REGISTER
    
	pipe_register 
	#(.WIDTH(102))
	if_id
	(
	.clk 		(clk),
	.rst		(rst),
	.D		({	PC_to_IM,
				Instruction,
				MEMWB_RW,
				MEMWB_DA,
				FU_out_pipe_2
			}),
	.Q		({	PC_pipe,
				Instruction_pipe,
				IFID_RW,
				IFID_DA,
				FU_out_pipe_3
			})
	);
	
	//FETCH PART END

	//DECODE
	
	LoadUse_Hazards LoadUse_Hazards_inst
	(
	.IDEX_MemRead		(MD_pipe),
	.IDEX_RegisterRd	(IDEX_DA),
	.IFID_RegisterRs1	(Instruction_pipe[19:15]),
	.IFID_RegisterRs2	(Instruction_pipe[24:20]),
	.LUHazard			(LUHazard)
	);

 
     
    MUX2 #(32) 
	MUXLw
	(
	.C0		(Instruction_pipe),
	.C1		(32'b0),
	.S		(LUHazard),
	.O		(New_Instruction)
	);
	
	Instruction_Decoder Instruction_Decoder_inst
	(
	.IR				(New_Instruction),
	.AA				(AA),
	.BA				(BA),
	.DA				(DA),
	.FS				(FS), 
	.RW				(RW), 
	.MB				(MB), 
	.MA				(MA), 
	.MD				(MD), 
	.MW				(MW),
	.PL				(PL), 
	.JB				(JB), 
	.BC				(BC), 
	.MEM_CONT		(MEM_CONT), 
	.im_sel			(im_sel),
	.data_sel		(data_sel)
	);
    
	Imm_Block Immediate_Block_inst
	(
	.inst		(New_Instruction),
	.im_sel		(im_sel),
	.im_out		(Imm)
	);
    
	   
	RegisterFile #
	(
	.SIZE(32)
	) 
	Register_File_inst
	(
    .clk			(clk),
    .rst			(rst),
    .Load_En		(!(write_disable) & MEMWB_RW),
    .A_sel			(AA),
    .B_sel			(BA),
    .D_data			(BUS_D),
    .Dest_sel		(MEMWB_DA),
    .A_data			(A_data),
    .B_data			(B_data)
    );
    
	//ID_EX PIPE REGISTER
	
	pipe_register 
	#(.WIDTH(162))
	id_ex
	(
	.clk		(clk),
	.rst		(rst),
	.D			({	Imm,
					PC_pipe,
					A_data,
					B_data,
					AA,
					BA,
					DA,
					RW,
					MA,
					MB,
					MD,
					MW,
					PL,
					JB,
					BC,
					MEM_CONT,
					data_sel,
					FS
				}),
	.Q			({	Imm_pipe,
					PC_pipe_2,
					A_data_pipe,
					B_data_pipe,
					IDEX_AA,
					IDEX_BA,
					IDEX_DA,
					IDEX_RW,
					MA_pipe,
					MB_pipe,
					MD_pipe,
					MW_pipe,
					PL_pipe,
					JB_pipe,
					BC_pipe,
					MEM_CONT_pipe,
					data_sel_pipe,
					FS_pipe
				})
	);
	
	//DECODE PART END
	
	//EXECUTE PART
	
	Forwarding_Unit Forwarding_Unit_inst
	(
    .EXMEM_RegWrite		   (EXMEM_RW        ),
    .EXMEM_RegisterRd	   (EXMEM_DA        ),
    .IDEX_RegisterRs1	   (IDEX_AA         ),
	.IFID_RegisterRs1	   (AA              ),
    .IDEX_RegisterRs2	   (IDEX_BA         ),
	.IFID_RegisterRs2	   (BA				),
    .MEMWB_RegWrite		   (MEMWB_RW  		),
    .MEMWB_RegisterRd	   (MEMWB_DA		),
    .Forward_A	 	       (Forward_A 		),
	.Forward_B	           (Forward_B       ),
	.IFID_RegisterRd       (IFID_DA			),                     
    .IFID_RegWrite         (IFID_RW			)                      

    ); 
	 

	
	 MUX2 #(32) 
	 MUXdataA
	 (
	 .C0	(FU_out_pipe_2),
	 .C1	(Data_in_pipe), 
	 .S		(MD_pipe_3[0]), 
	 .O		(TwoCycle)
	 );

	
	 MUX  #(32) 
	 MUX_ForwardA
	 (
	 .I0		(A_data_pipe),
	 .I1		(TwoCycle),
	 .I2		(FU_out_pipe),
	 .I3		(FU_out_pipe_3),
	 .S			(Forward_A),
	 .OUT		(BUS_Forward_A)
	 );
	
	 MUX  #(32) 
	 MUX_ForwardB
	 (
	 .I0		(B_data_pipe),
	 .I1		(TwoCycle),
	 .I2		(FU_out_pipe),
	 .I3		(FU_out_pipe_3),
	 .S			(Forward_B),
	 .OUT		(BUS_Forward_B));
	
	 MUX2 #(32) MUXB(.C0(BUS_Forward_B), .C1(Imm_pipe), .S(MB_pipe), .O(BUS_B));
    
     MUX2 #(32) MUXA(.C0(PC_pipe_2), .C1(BUS_Forward_A), .S(MA_pipe), .O(BUS_A));
    
	
     FU Function_Unit(
    .A		(BUS_A),
    .B		(BUS_B),
    .FS		(FS_pipe),
    .V		(V),
    .C		(C),
    .N		(N),
    .Z		(Z),
    .F		(FU_out)
    );
	
	Branch_Control_Block Branch_Control_Block_inst
	(
	.clk						(clk), 
	.rst						(rst),
	.V							(V),
	.C							(C),
	.N							(N),
	.Z							(Z),
	.Imm						(Imm_pipe), 
	.Address_out				(FU_out),
	.PL							(PL_pipe),
	.JB							(JB_pipe),
	.BC							(BC_pipe), 
	.PC_Control					(PC_Control),
	.load_disable				(load_disable_in)
	);
    
	
	//EX_MEM PIPE REGISTER
	
	pipe_register 
	#(.WIDTH(180))
	ex_mem
	(
	.clk			(clk),
	.rst			(rst),
	.D			({	PC_pipe_2,
					PC_Control,
					IDEX_DA,
					IDEX_RW,
					MD_pipe,
					MW_pipe,
					MEM_CONT_pipe,
					data_sel_pipe,
					FU_out,BUS_B,
					load_disable_in,
					BUS_Forward_B,
					IDEX_BA}
				),
	.Q			({	PC_pipe_3,
					PC_Control_pipe,
					EXMEM_DA,
					EXMEM_RW,
					MD_pipe_2,
					MW_pipe_2,
					MEM_CONT_pipe_2,
					data_sel_pipe_2,
					FU_out_pipe,
					BUS_B_pipe,
					load_disable_in_pipe,
					BUS_Forward_B_pipe,
					EXMEM_BA}
				)
	);
	
	
	//EXECUTE PART END
	
	
	//MEMORY PART
	


     LwSw_Control LOAD_CONTROL
	 (
	 .MEMWB_MD				(MD_pipe_3),
	 .EXMEM_MW				(MW_pipe_2),
	 .EXMEM_RegisterRs2		(EXMEM_BA),
	 .MEMWB_RegisterRd		(MEMWB_DA),
	 .LwSw_sel				(LwSw_sel)
	 );

	 MUX2 #(32) MUX_load_store
	 (
	 .C0		(BUS_Forward_B_pipe),
	 .C1		(Data_in_pipe),
	 .S			(LwSw_sel), 
	 .O			(BUS_B_lw)
	 );
	
	Data_memory 
	#(
	.ADDR_WIDTH	(5),
	.DATA_WIDTH	(32)
	)
	DataMemory_inst
	(
	.clk			(clk),
	.rst			(rst),
	.Address_out	(FU_out_pipe),
	.Data_out		(BUS_B_lw),
	.MW				(!(write_disable) & MW_pipe_2),
	.MEM_CONT		( MEM_CONT_pipe_2),
	.Data_in		(Data_in_wire)
	);
	 
	data_mem_extend data_mem_extend_inst
	(
	.data_in	(Data_in_wire),
	.data_sel	(data_sel_pipe_2),
	.data_out	(Data_in)
	); 
	

	
	//MEM_WB PIPE REGISTER
	
	
	pipe_register 
	#(.WIDTH(105))
	mem_wb
	(
	.clk			(clk),
	.rst			(rst),
	.D			({	PC_pipe_3,
					EXMEM_DA,
					EXMEM_RW,
					MD_pipe_2,
					FU_out_pipe,
					Data_in,
					load_disable_in_pipe
				}),
	.Q			({	PC_pipe_4,
					MEMWB_DA,
					MEMWB_RW,
					MD_pipe_3,
					FU_out_pipe_2,
					Data_in_pipe,
					load_disable_in_pipe_2
				})
	
	);
	


    add PC_ADD_inst
	(
	.A		(PC_pipe_4),
	.B		(32'd4),
	.Cout	(pc_c),
	.sum	(pc_rd)
	);
    
    MUX3 #(32) 
	MUXD
	(
	.C0		(FU_out_pipe_2),
	.C1		(Data_in_pipe),
	.C2		(pc_rd),
	.S		(MD_pipe_3),
	.O		(BUS_D)
	);	
	
	//MCP END
	

endmodule