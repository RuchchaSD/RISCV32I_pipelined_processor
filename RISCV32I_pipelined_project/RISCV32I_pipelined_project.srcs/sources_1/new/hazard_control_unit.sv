`timescale 1ns / 1ps

module hazard_control_unit#(
        parameter ADDRESS_LENGTH = 32
    )(
        input logic [2:0] memRead_out_id_ex, memRead_out_ex_mem,
        input logic [4:0] readReg1_in_id_ex, readReg2_in_id_ex, writeReg_out_id_ex,writeReg_out_ex_mem, //EX_MEMRegisterRd,
        output logic stall );

    // always @(memRead_out_id_ex, memRead_out_ex_mem, readReg1_in_id_ex, readReg2_in_id_ex, writeReg_out_id_ex, writeReg_out_ex_mem)
	 always_comb
//	always_ff @(negedge clk)
    begin
	  if((memRead_out_id_ex != 0||memRead_out_ex_mem != 0) && 
      ((writeReg_out_id_ex ==readReg1_in_id_ex)||(writeReg_out_id_ex ==readReg2_in_id_ex)||(writeReg_out_ex_mem ==readReg1_in_id_ex)||(writeReg_out_ex_mem ==readReg2_in_id_ex)))
	    begin
	      stall = 1;
	    end
	  else
	    begin
	      stall = 0;
	    end
	end


endmodule