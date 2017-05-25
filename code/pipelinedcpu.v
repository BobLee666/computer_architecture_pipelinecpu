`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    15:14:23 04/19/13
// Design Name:    
// Module Name:    pipelinedcpu
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module pipelinedcpu(clock,resetn,pc,inst,ealu,malu,walu
    );
	 input clock,resetn;
	 output [31:0] pc,inst,ealu,malu,walu;
	 wire [31:0] bpc,jpc,npc,pc4,ins,dpc4,inst,ea,eb,eimm,da,db,dimm;
	 wire [31:0] epc4,mb,mmo,wmo,wdi;
	 wire [4:0] drn,ern0,ern,mrn,wrn;
	 wire [4:0] daluc,ealuc;
	 wire [1:0] pcsource,E_BDEPEND,E_ADEPEND,D_BDEPEND,D_ADEPEND;
	 wire dwreg,dm2reg,dwmem,djal,D_WZ,D_BRANCH;
	 wire ewreg,em2reg,ewmem,ejal,E_WZ,DE_BRANCH;
	 wire mwreg,mm2reg,mwmem;
	 wire wwreg,wm2reg;
	 wire ez,mz;
	 wire INSTALL;
	 pipepc prog_cnt (npc,INSTALL,clock,resetn,pc);//���������PC
	 pipeif if_stage (pcsource,pc,bpc,da,jpc,npc,pc4,ins);//ȡָIF��
	 pipeir inst_reg (pc4,ins,INSTALL,clock,resetn,dpc4,inst);//IF����ID��֮��ļĴ�������ָ��Ĵ���IR
	 pipeid id_stage (dpc4,inst,                        //ָ������ID��
	                  wrn,wdi,wwreg,ewreg,em2reg,ern0,mwreg,mrn,mz,DE_BRANCH,clock,resetn,
							bpc,jpc,pcsource,dwreg,dm2reg,dwmem,
							daluc,D_BDEPEND,da,db,dimm,drn,D_ADEPEND,djal,D_WZ,INSTALL,D_BRANCH);
	 pipedereg de_reg (dwreg,dm2reg,dwmem,daluc,D_BDEPEND,da,db,dimm,//ID����EXE��֮��ļĴ���
	                   drn,D_ADEPEND,djal,dpc4,D_WZ,D_BRANCH,clock,resetn,
							 ewreg,em2reg,ewmem,ealuc,E_BDEPEND,ea,eb,eimm,
							 ern0,E_ADEPEND,ejal,epc4,E_WZ,DE_BRANCH);
	 pipeexe exe_stage (ealuc,E_ADEPEND,E_BDEPEND,
						ea,eb,eimm,walu,malu,ern0,epc4,ejal,
						ern,ealu,ez//ָ��ִ��EXE��
	                    );
	 pipeemreg em_reg (ewreg,em2reg,ewmem,ealu,eb,ern,ez,E_WZ,clock,resetn,//EXE����MEM��֮��ļĴ���
	                   mwreg,mm2reg,mwmem,malu,mb,mrn,mz);
	 IP_RAM mem_stage(mwmem,malu,mb,clock,mmo);//�洢������MEM��
	 pipemwreg mw_reg (mwreg,mm2reg,mmo,malu,mrn,clock,resetn,//MEM����WB��֮��ļĴ���
	                   wwreg,wm2reg,wmo,walu,wrn);
	 mux2x32 wb_stage (walu,wmo,wm2reg,wdi);//���д��WB����ѡ����д�ص���Դ��ALU�������ݴ洢��
endmodule