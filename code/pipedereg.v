`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:18 10/26/2012 
// Design Name: 
// Module Name:    pipedereg 
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

module pipedereg(dwreg,dm2reg,dwmem,daluc,D_BDEPEND,da,db,dimm,drn,
                 D_ADEPEND,djal,dpc4,D_WZ,D_BRANCH,clk,clrn,
				 ewreg,em2reg,ewmem,ealuc,E_BDEPEND,ea,eb,eimm,
				 ern,E_ADEPEND,ejal,epc4,E_WZ,DE_BRANCH
    );
	 input [31:0] da,db,dimm,dpc4;
	 input [4:0] drn;
	 input [4:0] daluc;
	 input [1:0] D_BDEPEND,D_ADEPEND;
	 input dwreg,dm2reg,dwmem,djal,D_WZ,D_BRANCH;
	 input clk,clrn;
	 output [1:0] E_BDEPEND,E_ADEPEND;
	 output [31:0] ea,eb,eimm,epc4;
	 output [4:0] ern;
	 output [4:0] ealuc;
	 output ewreg,em2reg,ewmem,ejal,E_WZ,DE_BRANCH;
	 reg [31:0] ea,eb,eimm,epc4;
	 reg [4:0] ern;
	 reg [4:0] ealuc;
	 reg [1:0] E_BDEPEND,E_ADEPEND;
	 reg ewreg,em2reg,ewmem,ejal,E_WZ,DE_BRANCH;
	 always @(negedge clrn or posedge clk)
	     if(clrn==0)
		      begin
				    ewreg<=0;    em2reg<=0;
					 ewmem<=0;    ealuc<=0;
					 E_BDEPEND<=0;  ea<=0;
					 eb<=0;       eimm<=0;
					 ern<=0;      E_ADEPEND<=0;
					 ejal<=0;     epc4<=0;
					 E_WZ<=0;     DE_BRANCH<=0;
			   end
			else
			    begin
				    ewreg<=dwreg;    em2reg<=dm2reg;
					 ewmem<=dwmem;    ealuc<=daluc;
					 E_BDEPEND<=D_BDEPEND;  ea<=da;
					 eb<=db;       eimm<=dimm;
					 ern<=drn;      E_ADEPEND<=D_ADEPEND;
					 ejal<=djal;     epc4<=dpc4;
					 E_WZ<=D_WZ;     DE_BRANCH<=D_BRANCH;
				 end

endmodule
