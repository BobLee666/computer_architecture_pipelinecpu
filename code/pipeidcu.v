`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:16 10/26/2012 
// Design Name: 
// Module Name:    pipeidcu 
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
module pipeidcu(rsrtequ,func,ewreg,em2reg,ern,mwreg,mrn,rs,rt,rd,
	             op,wreg,m2reg,wEXE,aluc,regrt,BDEPEND,EM_BRANCH,
					 sext,pcsource,ADEPEND,jal,D_WZ,LOADDEPEN,D_BRANCH
    );
	 input rsrtequ,ewreg,em2reg,mwreg,EM_BRANCH; 
	 input [5:0] func,op;
	 input [4:0] rs,rt,rd,ern,mrn;
	 output wreg,m2reg,wEXE,regrt,sext,jal,D_WZ,LOADDEPEN,D_BRANCH;
	 output [4:0] aluc;
	 output [1:0] pcsource,BDEPEND,ADEPEND;
	 wire i_add,i_sub,i_mul,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;            //对指令进行译码
	 wire i_addi,i_muli,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
	 
	 wire AEXEDEPEND,AMEMDEPEND,BEXEDEPEND,BMEMDEPEND;
	 and(i_add,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],~func[1],func[0]);
	 and(i_sub,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],func[1],~func[0]);
	 and(i_mul,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],func[1],func[0]);
	
	 
	 and(i_and,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],~func[1],func[0]);
	 and(i_or,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],func[1],~func[0]);
	
	 and(i_xor,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],func[2],~func[1],~func[0]);
	 
	 and(i_sra,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],~func[1],func[0]);
	 and(i_srl,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],~func[0]);
	 and(i_sll,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],func[0]);
	 and(i_jr,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],func[2],~func[1],~func[0]);
	 
	 and(i_addi,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);
	
	 and(i_muli,~op[5],~op[4],~op[3],op[2],op[1],op[0]);
	 
	 
	 and(i_andi,~op[5],~op[4],op[3],~op[2],~op[1],op[0]);
	 and(i_ori,~op[5],~op[4],op[3],~op[2],op[1],~op[0]);

	 and(i_xori,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);
	 
	 and(i_lw,~op[5],~op[4],op[3],op[2],~op[1],op[0]);
	 and(i_sw,~op[5],~op[4],op[3],op[2],op[1],~op[0]);
	 and(i_beq,~op[5],~op[4],op[3],op[2],op[1],op[0]);
	 and(i_bne,~op[5],op[4],~op[3],~op[2],~op[1],~op[0]);
	 and(i_lui,~op[5],op[4],~op[3],~op[2],~op[1],op[0]);
	 and(i_j,~op[5],op[4],~op[3],~op[2],op[1],~op[0]);
	 and(i_jal,~op[5],op[4],~op[3],~op[2],op[1],op[0]);
	
	 wire i_rs=i_add|i_sub|i_mul|i_and|i_or|i_xor|i_jr|i_addi|i_muli|           
	           i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne;
	 wire i_rt=i_add|i_sub|i_mul|i_and|i_or|i_xor|i_sra|i_srl|i_sll|i_sw|i_beq|i_bne;//i_rt=1表示rt作为源操作数
	 
    ////////////////////////////////////////////控制信号的生成/////////////////////////////////////////////////////////
    assign wreg=(i_add|i_sub|i_mul|i_and|i_or|i_xor|i_sll|           //wreg为1时写寄存器堆中某一寄存器，否则不写
	              i_srl|i_sra|i_addi|i_muli|i_andi|i_ori|i_xori|
					  i_lw|i_lui|i_jal)&(~EM_BRANCH);
	 assign regrt=i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_lui;    //regrt为1时目的寄存器是rt，否则为rd
	 assign jal=i_jal;                                           //为1时执行jal指令，否则不是
	 assign m2reg=i_lw;  //为1时将存储器数据写入寄存器，否则将ALU结果写入寄存器
	 
	 assign shift=i_sll|i_srl|i_sra;//为1时ALUa输入端使用移位位数
	 assign aluimm=i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_lui|i_sw;//为1时ALUb输入端使用立即数
	 
	 assign D_WZ=(~EM_BRANCH)&(i_add|i_sub|i_mul|i_and|i_or|i_xor|i_jr|i_addi|i_muli|           
	           i_andi|i_ori|i_xori);
				  
				  	 
	
	 
	 assign ADEPEND[0]= ( mwreg & (rs==mrn) & i_rs) | shift;
	 assign ADEPEND[1]= (ewreg & (rs==ern) & i_rs) | (i_rs & mwreg & (rs==mrn));
	 
						
	 assign BDEPEND[0]= (i_rt & mwreg & (rt==mrn)) | aluimm;
	 assign BDEPEND[1]=(i_rt & ewreg & (rt==ern)) | (i_rt & mwreg & (rt==mrn));
	 
	 
	 assign LOADDEPEN=((i_rs)&(em2reg)&(rs==ern))+((i_rt)&(em2reg)&(rt==ern))
						+((i_bne|i_beq)&ewreg&(~em2reg));    //这里load和bne的暂停都考虑了
	 
	 
	 assign sext=i_addi|i_muli|i_lw|i_sw|i_beq|i_bne;//为1时符号拓展，否则零拓展
	 assign aluc[4]=i_sra;//ALU的控制码
	 assign aluc[3]=i_sub|i_or|i_ori|i_xor|i_xori| i_srl|i_sra|i_beq|i_bne;//ALU的控制码
	 assign aluc[2]=i_sll|i_srl|i_sra|i_lui;//ALU的控制码
	 assign aluc[1]=i_and|i_andi|i_or|i_ori|i_xor|i_xori|i_beq|i_bne;//ALU的控制码
	 assign aluc[0]=i_mul|i_muli|i_xor|i_xori|i_sll|i_srl|i_sra|i_beq|i_bne;//ALU的控制码

	 assign wEXE=(i_sw)&(~EM_BRANCH);//为1时写存储器，否则不写
	 assign D_BRANCH=i_j|i_bne|i_beq; //为1时封锁WZ,WMEM,WREG
	 assign pcsource[1]=i_jr|i_j|i_jal;//选择下一条指令的地址，00选PC+4,01选转移地址，10选寄存器内地址，11选跳转地址
	 assign pcsource[0]=i_beq&rsrtequ|i_bne&~rsrtequ|i_j|i_jal;
	
endmodule
