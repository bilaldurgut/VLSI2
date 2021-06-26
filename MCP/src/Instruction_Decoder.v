`timescale 1ns / 1ps


module Instruction_Decoder(
    input [31:0] IR,
    output reg [4:0] AA, BA, DA,
    output reg [3:0] FS,
    output reg RW, MB, MW, MA, // Load_En, mb, md, MW
    output reg [1:0] MD,
    output reg PL, JB,
    output reg [1:0] BC, MEM_CONT,
    output  reg [2:0] im_sel, data_sel

    );
    
    wire [4:0] DA_addr, A_addr, B_addr;
    wire [6:0] Opcode;
    
    assign Opcode = IR[6:0];
    assign DA_addr = IR[11:7];
    assign A_addr = IR[19:15];
    assign B_addr = IR[24:20];
    
    always @(*)
    begin
    case(Opcode)
    
        7'b0110111:  //LUI
        begin
        
            AA = A_addr;
            BA = B_addr;
            DA = DA_addr;
            MB = 1'b1; // get imm value
            MA = 1'b1;
            MD = 2'd0;
            PL = 1'd0; 
            JB = 1'd0;
            BC = 2'b00;
            RW = 1'b1;
            MW = 1'b0;
            MEM_CONT = 2'b10; //32 bit data
            data_sel = 3'd4; //
            im_sel = 3'd3; // U-type
            FS = 4'b0111; //  B de�erini ��k��a transfer eder.(Load)
//             FS = 4'b0000;
         end
        
        
        /////AUIPC!!!!!!!
        7'b0010111:  //AUIPC
        begin
            AA = A_addr;
            BA = B_addr;
            DA = DA_addr;
            MB = 1'b1; // get imm value
            MA = 1'b0; //PC se�ilir.
            MD = 2'd0;
            PL = 1'd0; 
            JB = 1'd0;
            BC = 2'b00;
            RW = 1'b1;
            MW = 1'b0;
            MEM_CONT = 2'b10; //32 bit data
            data_sel = 3'd4; // �nemi yok
            im_sel = 3'd3; // U-type
            FS = 4'b0000; //  Imm + PC i�lemi yap�l�r.
        
        end    
        
        
        ///// JAL!!!!!!!!!!!!!!!!!!!!!!
        7'b1101111:  //JAL
        begin
        
            AA = A_addr;
            BA = B_addr;
            DA = DA_addr;
            MB = 1'b1; // get imm value
            MA = 1'b0; //PC se�ilir.
            MD = 2'd2; //pc + 4 yazilir.
            PL = 1'd1; 
            JB = 1'd1;
            BC = 2'b00; // pc + imm e gider.   //14.06 3den 0 a de�i�ti
            RW = 1'b1;
            MW = 1'b0;
            MEM_CONT = 2'b10; //32 bit data
            data_sel = 3'd4; // �nemi yok
            im_sel = 3'd4; // J-type
            FS = 4'b0000; //  imm + PC i�lemi yap�l�r.
        
        end       
        
        7'b1100111:  //JALR
        begin
        
            AA = A_addr;
            BA = B_addr;
            DA = DA_addr;
            MB = 1'b1; // get imm value
            MA = 1'b1; // reg degeri rs1 se�ilir.
            MD = 2'd2; //pc + 4 yazilir.
            PL = 1'd1; 
            JB = 1'd1;
            BC = 2'b00; // addressout = [rs1] + imm e gider.
            RW = 1'b1;
            MW = 1'b0;
            MEM_CONT = 2'b10; //32 bit data
            data_sel = 3'd4; // �nemi yok
            im_sel = 3'd0; // J-type
            FS = 4'b0000; //  address_outu almak icin add i�lemi yap�l�r.
        
        end      
        
        
        7'b1100011:
        begin
            case(IR[14:12])
                3'b000: //BEQ
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger al�n�r. 2 register degeri kar��la�t�r�l�r.
                    MA = 1'b1; //reg A de�eri
                    MD = 2'd0;
                    PL = 1'd1; 
                    JB = 1'd0;
                    BC = 2'b00;
                    RW = 1'b0;
                    MW = 1'b0;
                    MEM_CONT = 2'b10; //32 bit data
                    data_sel = 3'd4; // 32 bit
                    im_sel = 3'd2; // B-type
                    FS = 4'b0001;    //compare - zero flag bak�l�r
                    
                end
    
                3'b001: //BNE
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger al�n�r. 2 register degeri kar��la�t�r�l�r.
                    MA = 1'b1;
                    MD = 2'd0;
                    PL = 1'd1; 
                    JB = 1'd0;
                    BC = 2'b01;
                    RW = 1'b0;
                    MW = 1'b0;
                    MEM_CONT = 2'b10; //32 bit data
                    data_sel = 3'd4; // 32 bit
                    im_sel = 3'd2; // B-type
                    FS = 4'b0001;    //compare - zero flag bak�l�r
                    
                end
    
                3'b100: //BLT
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger al�n�r. 2 register degeri kar��la�t�r�l�r.
                    MA = 1'b1;
                    MD = 2'd0;
                    PL = 1'd1; 
                    JB = 1'd0;
                    BC = 2'b11;
                    RW = 1'b0;
                    MW = 1'b0;
                    MEM_CONT = 2'b10; //32 bit data
                    data_sel = 3'd4; // 32 bit
                    im_sel = 3'd2; // B-type
                    FS = 4'b0011;    //compare - zero flag bak�l�r SLT yapar.
                    
                end  
            
                3'b101: //BGE
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger al�n�r. 2 register degeri kar��la�t�r�l�r.
                    MA = 1'b1;
                    MD = 2'd0;
                    PL = 1'd1; 
                    JB = 1'd0;
                    BC = 2'b10;
                    RW = 1'b0;
                    MW = 1'b0;
                    MEM_CONT = 2'b10; //32 bit data
                    data_sel = 3'd4; // 32 bit
                    im_sel = 3'd2; // B-type
                    FS = 4'b0011;    //compare - zero flag bak�l�r SLT yapar.
                    
                 end   
    
                3'b110: //BLTU
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger al�n�r. 2 register degeri kar��la�t�r�l�r.
                    MA = 1'b1;
                    MD = 2'd0;
                    PL = 1'd1; 
                    JB = 1'd0;
                    BC = 2'b11;
                    RW = 1'b0;
                    MW = 1'b0;
                    MEM_CONT = 2'b10; //32 bit data
                    data_sel = 3'd4; // 32 bit
                    im_sel = 3'd2; // B-type
                    FS = 4'b0010;    //compare - zero flag bak�l�r SLTU yapacak.
                    
                end  
    
                3'b111: //BGEU
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger al�n�r. 2 register degeri kar��la�t�r�l�r.
                    MA = 1'b1;
                    MD = 2'd0;
                    PL = 1'd1; 
                    JB = 1'd0;
                    BC = 2'b10;
                    RW = 1'b0;
                    MW = 1'b0;
                    MEM_CONT = 2'b10; //32 bit data
                    data_sel = 3'd4; // 32 bit
                    im_sel = 3'd2; // B-type
                    FS = 4'b0010;    //compare - zero flag bak�l�r SLTU yapcak.
                    
                 end  
    
                   
            endcase
        end
        //LB-SB opcodelular
        
        7'b0000011:  //!!!!!!!!!!!!!!!!!BAK
        begin
            case(IR[14:12])
                3'b000: //LB
                    begin
                            AA = A_addr;
                            BA = B_addr; //0 verilebilir belki
                            DA = DA_addr;
                            MB = 1'b1; //imm degeri
                            MA = 1'b1;
                            MD = 2'd1; //memory okumas�
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yap�l�yor. ???? GER� D�N BAK
                            MEM_CONT = 2'b0;
                            data_sel = 3'd0; // Byte okur
                            im_sel = 3'd0; // I-type .
                            FS = 4'b0000; // Imm + rs1 - > Memory'nin address outu olur.
                    end  
    
                3'b001: //LH
                    begin
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b1; //imm degeri
                            MA = 1'b1;
                            MD = 2'd1; //memory okumas�
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yap�l�yor. ???? GER� D�N BAK
                            MEM_CONT = 2'd1;
                            data_sel = 3'd1; // Half signed
                            im_sel = 3'd0; // I-type .
                            FS = 4'b0000; //Imm + rs1
                    end  
     
                 3'b010: //LW
                    begin
                            AA = A_addr;
                            BA = B_addr; //0 B de�eri yok..
                            DA = DA_addr;
                            MB = 1'b1; //imm degeri
                            MA = 1'b1;
                            MD = 2'd1; //memory okumas�
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yap�l�yor. ???? GER� D�N BAK
                            MEM_CONT = 2'd2;
                            data_sel = 3'd4; // 32 bit
                            im_sel = 3'd0; // I-type .
                            FS = 4'b0000; //Anlam ifade etmez kullan�lm�yor.
                            
                    end 
    
                 3'b100: //LBU
                    begin
                    
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b1; //imm degeri
                            MA = 1'b1;
                            MD = 2'd1; //memory okumas�
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yap�l�yor. ???? GER� D�N BAK
                            MEM_CONT = 2'd0;
                            data_sel = 3'd2; //Unsigned Byte
                            im_sel = 3'd0; // I-type .
                            FS = 4'b0000; // Imm + rs1
                            
                    end 
    
                 3'b101: //LHU
                    begin
                    
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b1; //imm degeri
                            MA = 1'b1;
                            MD = 2'd1; //memory okumas�
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yap�l�yor. ???? GER� D�N BAK
                            MEM_CONT = 2'd1; //okuma yap�yor anlam� yok. z olmas�n diye.
                            data_sel = 3'd3; //unsigned Halfword
                            im_sel = 3'd0; // I-type .
                            FS = 4'b0000; // Imm + rs1
                            
                    end 
                        
             endcase              
        end
        
        7'b0100011: 
        begin
            case(IR[14:12])
                3'b000: //SB
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; //imm degeri
                        MA = 1'b1;
                        MD = 2'd0; //memory yazmas� c�k�sa gerek yok
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b0;
                        MW = 1'b1; //Yazma yap�l�yor. ???? GER� D�N BAK
                        MEM_CONT = 2'd0; //Byte yazacak.
                        data_sel = 3'd0; // �nemsiz
                        im_sel = 3'd1; // S-type .
                        FS = 4'b0000; // Imm + rs1 
                end     
     
     
                3'b001: //SH
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; //imm degeri
                        MA = 1'b1;
                        MD = 2'd0; //memory yazmas� c�k�sa gerek yok
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b0;
                        MW = 1'b1; //Yazma yap�l�yor. ???? GER� D�N BAK
                        MEM_CONT = 2'd1;
                        data_sel = 3'd1; //
                        im_sel = 3'd1; // S-type .
                        FS = 4'b0000; //
                end     
                
                3'b010: //SW
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; //imm degeri
                        MA = 1'b1;
                        MD = 2'd0; //memory yazmas� c�k�sa gerek yok
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b0;
                        MW = 1'b1; //Yazma yap�l�yor. ???? GER� D�N BAK
                        MEM_CONT = 2'd2;
                        data_sel = 3'd4; //
                        im_sel = 3'd1; // S-type .
                        FS = 4'b0000; //
                end          
            endcase
        end
        
        
        7'b0010011:
        begin
            case(IR[14:12])
                3'b000: //ADDI
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; // imm se�
                        MA = 1'b1; // rega se�
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10; //�nemi yok
                        data_sel = 3'd4; // �nemi yok
                        im_sel = 3'd0; // I-type .
                        FS = 4'b0000; // add
                end  
         
                3'b010: //SLTI
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; //imm degeri
                        MA = 1'b1;
                        MD = 2'd0; //alu ��k���
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10;
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // I-type.
                        FS = 4'b0011; // SLT yapar
                end 
                   
                3'b011: //SLTIU
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10;
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // I-type.
                        FS = 4'b0010; //SLTU unsigned compare yap.
                end      
         
                3'b100: //XORI
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10;
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // I-type.
                        FS = 4'b0100; 
                end              
         
                3'b110: // ORI
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10;
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // I-type.
                        FS = 4'b0101; 
                end                      
         
                3'b111: //ANDI
                begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10;
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // I-type.
                        FS = 4'b0110; 
                end      
            
                3'b001: // SLLI - Logical Left
                    begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b1; //shamt!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10; //32 bit
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // I-type imm de�eri yok 0 verildi.
                        FS = 4'b1000; 
                    end   
                  
                 3'b101: // Shift right - arithemetic
                 begin
                     case(IR[31:25])
                        7'b0000000: //SRLI
                        begin
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b1; 
                            MA = 1'b1;
                            MD = 2'd0;
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0;
                            MEM_CONT = 2'b10; //32 bit
                            data_sel = 3'd4; //
                            im_sel = 3'd0; // I-type imm de�eri yok 0 verildi.
                            FS = 4'b1001; 
                        end  
         
                         7'b0100000: // SRAI
                         begin
                                AA = A_addr;
                                BA = B_addr;
                                DA = DA_addr;
                                MB = 1'b1; 
                                MA = 1'b1;
                                MD = 2'd0;
                                PL = 1'd0; 
                                JB = 1'd0;
                                BC = 2'b00;
                                RW = 1'b1;
                                MW = 1'b0;
                                MEM_CONT = 2'b10; //32 bit
                                data_sel = 3'd4; //
                                im_sel = 3'd0; // I-type imm de�eri yok 0 verildi.
                                FS = 4'b1011; 
                         end  
                    endcase    
                end        
            endcase       
        end
        
        //ADD-SUBB opcode'lu olanlar
        
        7'b0110011:
        begin
            case(IR[14:12])
                3'b000:
                begin
                    case(IR[31:25]) //func7 kontrolu
                        7'b0000000: //ADD
                        begin
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b0; 
                            MA = 1'b1;
                            MD = 2'd0;
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0;
                            MEM_CONT = 2'b10;
                            data_sel = 3'd4; //
                            im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                            FS = 4'b0000; 
                        end
        
                        7'b0100000: //SUB
                        begin
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b0; 
                            MA = 1'b1;
                            MD = 2'd0;
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0;
                            MEM_CONT = 2'b10; //32 bit
                            data_sel = 3'd4; //
                            im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                            FS = 4'b0001; 
                        end  
                    endcase 
                end    
                
                3'b001: // SLL - Logical Left
                    begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b0; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10; //32 bit
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // I-type imm de�eri yok 0 verildi.
                        FS = 4'b1000; 
                    end        
                  
                3'b010: // SLT
                    begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b0; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10; //32 bit
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                        FS = 4'b0011; //signed icin SLT
                    end      
                 
         
             /// SLTU !!!!!!!!!!!!!!!!!
                 3'b011: // SLTU
                    begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b0; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10; //32 bit
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                        FS = 4'b0010;  //unsigned icin SLTU
                    end      
         
         
                 3'b100: // XOR
                    begin
                        AA = A_addr;
                        BA = B_addr;
                        DA = DA_addr;
                        MB = 1'b0; 
                        MA = 1'b1;
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10; //32 bit
                        data_sel = 3'd4; //
                        im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                        FS = 4'b0100; 
                    end  
         
                 3'b101: // Shift right - arithemetic
                 begin
                     case(IR[31:25])
                        7'b0000000: //SRL
                            begin
                                AA = A_addr;
                                BA = B_addr;
                                DA = DA_addr;
                                MB = 1'b0; 
                                MA = 1'b1;
                                MD = 2'd0;
                                PL = 1'd0; 
                                JB = 1'd0;
                                BC = 2'b00;
                                RW = 1'b1;
                                MW = 1'b0;
                                MEM_CONT = 2'b10; //32 bit
                                data_sel = 3'd4; //
                                im_sel = 3'd0; // I-type imm de�eri yok 0 verildi.
                                FS = 4'b1001; 
                            end  
                 
                         7'b0100000: // SRA
                            begin
                                AA = A_addr;
                                BA = B_addr;
                                DA = DA_addr;
                                MB = 1'b0; 
                                MA = 1'b1;
                                MD = 2'd0;
                                PL = 1'd0; 
                                JB = 1'd0;
                                BC = 2'b00;
                                RW = 1'b1;
                                MW = 1'b0;
                                MEM_CONT = 2'b10; //32 bit
                                data_sel = 3'd4; //
                                im_sel = 3'd0; // I-type imm de�eri yok 0 verildi.
                                FS = 4'b1011; 
                            end  
                        endcase
                    end
                    
                    3'b110: //OR
                        begin
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b0; 
                            MA = 1'b1;
                            MD = 2'd0;
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0;
                            MEM_CONT = 2'b10; //32 bit
                            data_sel = 3'd4; //
                            im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                            FS = 4'b0101; 
                        end         
          
                      3'b111: //AND
                        begin
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b0; 
                            MA = 1'b1;
                            MD = 2'd0;
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0;
                            MEM_CONT = 2'b10; //32 bit
                            data_sel = 3'd4; //
                            im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                            FS = 4'b0110; 
                        end         
                          
            endcase
            end
           default:
           begin
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b0; 
                            MA = 1'b1;
                            MD = 2'd0;
                            PL = 1'd1; 
                            JB = 1'd1;
                            BC = 2'b10;
                            RW = 1'b1;
                            MW = 1'b0;
                            MEM_CONT = 2'b10; //32 bit
                            data_sel = 3'd4; //
                            im_sel = 3'd0; // R-type imm de�eri yok 0 verildi.
                            FS = 4'b0111;           
           end
           
    endcase
    end
    
endmodule
