`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:59 10/25/2012 
// Design Name: 
// Module Name:    pipeid 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pipeid(dpc4,inst,wrn,
              wdi,wwreg,ewreg,em2reg,ern0,mwreg,mrn,rsrtequ,EM_BRANCH,clk,clrn,
			  bpc,jpc,pcsource,
			  wreg,m2reg,wmem,aluc,BDEPEND,a,b,imm,rn,
			  ADEPEND,jal,D_WZ,LOADDEPEN,D_BRANCH
    );
	 input [31:0] dpc4,inst,wdi;
	 input [4:0] wrn,ern0,mrn;
	 input wwreg,ewreg,em2reg,mwreg,EM_BRANCH;
	 input clk,clrn;
	 input rsrtequ;
	 output [31:0] bpc,jpc,a,b,imm;
	 output [4:0] rn;
	 output [4:0] aluc;
	 output [1:0] pcsource,BDEPEND,ADEPEND;
	 output wreg,m2reg,wmem,jal,D_WZ,LOADDEPEN,D_BRANCH;
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd;
	 wire [31:0] qa,qb,br_offset;
	 wire [15:0] ext16;
	 wire regrt,sext,e;
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 assign jpc={dpc4[31:28],inst[25:0],2'b00};//jump,jalָ���Ŀ���ַ�ļ���
	 pipeidcu cu(rsrtequ,func,ewreg,em2reg,ern0,mwreg,mrn,rs,rt,rd,                      //���Ʋ���
	             op,wreg,m2reg,wmem,aluc,regrt,BDEPEND,EM_BRANCH,
					 sext,pcsource,ADEPEND,jal,D_WZ,LOADDEPEN,D_BRANCH);
    regfile rf (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb);//�Ĵ����ѣ���32��32λ�ļĴ�����0�żĴ�����Ϊ0
	 mux2x5 des_reg_no (rd,rt,regrt,rn); //ѡ��Ŀ�ļĴ�����������rd,����rt
	 assign a=qa;
	 assign b=qb;
	 assign e=sext&inst[25];//������չ��0��չ
	 assign ext16={16{e}};//������չ
	 assign imm={ext16,inst[25:10]};//�����������з�����չ
	 assign br_offset={imm[29:0],2'b00};
	 cla32 br_addr (dpc4,br_offset,1'b0,bpc);//beq,bneָ���Ŀ���ַ�ļ���
	 
	
endmodule
