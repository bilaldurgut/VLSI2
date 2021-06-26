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
            FS = 4'b0111; //  B deðerini çýkýþa transfer eder.(Load)
//             FS = 4'b0000;
         end
        
        
        /////AUIPC!!!!!!!
        7'b0010111:  //AUIPC
        begin
            AA = A_addr;
            BA = B_addr;
            DA = DA_addr;
            MB = 1'b1; // get imm value
            MA = 1'b0; //PC seçilir.
            MD = 2'd0;
            PL = 1'd0; 
            JB = 1'd0;
            BC = 2'b00;
            RW = 1'b1;
            MW = 1'b0;
            MEM_CONT = 2'b10; //32 bit data
            data_sel = 3'd4; // önemi yok
            im_sel = 3'd3; // U-type
            FS = 4'b0000; //  Imm + PC iþlemi yapýlýr.
        
        end    
        
        
        ///// JAL!!!!!!!!!!!!!!!!!!!!!!
        7'b1101111:  //JAL
        begin
        
            AA = A_addr;
            BA = B_addr;
            DA = DA_addr;
            MB = 1'b1; // get imm value
            MA = 1'b0; //PC seçilir.
            MD = 2'd2; //pc + 4 yazilir.
            PL = 1'd1; 
            JB = 1'd1;
            BC = 2'b00; // pc + imm e gider.   //14.06 3den 0 a deðiþti
            RW = 1'b1;
            MW = 1'b0;
            MEM_CONT = 2'b10; //32 bit data
            data_sel = 3'd4; // önemi yok
            im_sel = 3'd4; // J-type
            FS = 4'b0000; //  imm + PC iþlemi yapýlýr.
        
        end       
        
        7'b1100111:  //JALR
        begin
        
            AA = A_addr;
            BA = B_addr;
            DA = DA_addr;
            MB = 1'b1; // get imm value
            MA = 1'b1; // reg degeri rs1 seçilir.
            MD = 2'd2; //pc + 4 yazilir.
            PL = 1'd1; 
            JB = 1'd1;
            BC = 2'b00; // addressout = [rs1] + imm e gider.
            RW = 1'b1;
            MW = 1'b0;
            MEM_CONT = 2'b10; //32 bit data
            data_sel = 3'd4; // önemi yok
            im_sel = 3'd0; // J-type
            FS = 4'b0000; //  address_outu almak icin add iþlemi yapýlýr.
        
        end      
        
        
        7'b1100011:
        begin
            case(IR[14:12])
                3'b000: //BEQ
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger alýnýr. 2 register degeri karþýlaþtýrýlýr.
                    MA = 1'b1; //reg A deðeri
                    MD = 2'd0;
                    PL = 1'd1; 
                    JB = 1'd0;
                    BC = 2'b00;
                    RW = 1'b0;
                    MW = 1'b0;
                    MEM_CONT = 2'b10; //32 bit data
                    data_sel = 3'd4; // 32 bit
                    im_sel = 3'd2; // B-type
                    FS = 4'b0001;    //compare - zero flag bakýlýr
                    
                end
    
                3'b001: //BNE
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger alýnýr. 2 register degeri karþýlaþtýrýlýr.
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
                    FS = 4'b0001;    //compare - zero flag bakýlýr
                    
                end
    
                3'b100: //BLT
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger alýnýr. 2 register degeri karþýlaþtýrýlýr.
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
                    FS = 4'b0011;    //compare - zero flag bakýlýr SLT yapar.
                    
                end  
            
                3'b101: //BGE
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger alýnýr. 2 register degeri karþýlaþtýrýlýr.
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
                    FS = 4'b0011;    //compare - zero flag bakýlýr SLT yapar.
                    
                 end   
    
                3'b110: //BLTU
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger alýnýr. 2 register degeri karþýlaþtýrýlýr.
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
                    FS = 4'b0010;    //compare - zero flag bakýlýr SLTU yapacak.
                    
                end  
    
                3'b111: //BGEU
                begin
                
                    AA = A_addr;
                    BA = B_addr;
                    DA = DA_addr;
                    MB = 1'b0; // registerdaki deger alýnýr. 2 register degeri karþýlaþtýrýlýr.
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
                    FS = 4'b0010;    //compare - zero flag bakýlýr SLTU yapcak.
                    
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
                            MD = 2'd1; //memory okumasý
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yapýlýyor. ???? GERÝ DÖN BAK
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
                            MD = 2'd1; //memory okumasý
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yapýlýyor. ???? GERÝ DÖN BAK
                            MEM_CONT = 2'd1;
                            data_sel = 3'd1; // Half signed
                            im_sel = 3'd0; // I-type .
                            FS = 4'b0000; //Imm + rs1
                    end  
     
                 3'b010: //LW
                    begin
                            AA = A_addr;
                            BA = B_addr; //0 B deðeri yok..
                            DA = DA_addr;
                            MB = 1'b1; //imm degeri
                            MA = 1'b1;
                            MD = 2'd1; //memory okumasý
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yapýlýyor. ???? GERÝ DÖN BAK
                            MEM_CONT = 2'd2;
                            data_sel = 3'd4; // 32 bit
                            im_sel = 3'd0; // I-type .
                            FS = 4'b0000; //Anlam ifade etmez kullanýlmýyor.
                            
                    end 
    
                 3'b100: //LBU
                    begin
                    
                            AA = A_addr;
                            BA = B_addr;
                            DA = DA_addr;
                            MB = 1'b1; //imm degeri
                            MA = 1'b1;
                            MD = 2'd1; //memory okumasý
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yapýlýyor. ???? GERÝ DÖN BAK
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
                            MD = 2'd1; //memory okumasý
                            PL = 1'd0; 
                            JB = 1'd0;
                            BC = 2'b00;
                            RW = 1'b1;
                            MW = 1'b0; //Okuma yapýlýyor. ???? GERÝ DÖN BAK
                            MEM_CONT = 2'd1; //okuma yapýyor anlamý yok. z olmasýn diye.
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
                        MD = 2'd0; //memory yazmasý cýkýsa gerek yok
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b0;
                        MW = 1'b1; //Yazma yapýlýyor. ???? GERÝ DÖN BAK
                        MEM_CONT = 2'd0; //Byte yazacak.
                        data_sel = 3'd0; // önemsiz
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
                        MD = 2'd0; //memory yazmasý cýkýsa gerek yok
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b0;
                        MW = 1'b1; //Yazma yapýlýyor. ???? GERÝ DÖN BAK
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
                        MD = 2'd0; //memory yazmasý cýkýsa gerek yok
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b0;
                        MW = 1'b1; //Yazma yapýlýyor. ???? GERÝ DÖN BAK
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
                        MB = 1'b1; // imm seç
                        MA = 1'b1; // rega seç
                        MD = 2'd0;
                        PL = 1'd0; 
                        JB = 1'd0;
                        BC = 2'b00;
                        RW = 1'b1;
                        MW = 1'b0;
                        MEM_CONT = 2'b10; //önemi yok
                        data_sel = 3'd4; // önemi yok
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
                        MD = 2'd0; //alu çýkýþý
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
                        im_sel = 3'd0; // I-type imm deðeri yok 0 verildi.
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
                            im_sel = 3'd0; // I-type imm deðeri yok 0 verildi.
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
                                im_sel = 3'd0; // I-type imm deðeri yok 0 verildi.
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
                            im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
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
                            im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
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
                        im_sel = 3'd0; // I-type imm deðeri yok 0 verildi.
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
                        im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
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
                        im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
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
                        im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
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
                                im_sel = 3'd0; // I-type imm deðeri yok 0 verildi.
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
                                im_sel = 3'd0; // I-type imm deðeri yok 0 verildi.
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
                            im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
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
                            im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
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
                            im_sel = 3'd0; // R-type imm deðeri yok 0 verildi.
                            FS = 4'b0111;           
           end
           
    endcase
    end
    
endmodule
