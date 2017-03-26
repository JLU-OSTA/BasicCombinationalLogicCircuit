`timescale 1ns / 1ns

module CPU_Address_Decoder(addr,rom_select,ram_select);
output rom_select,ram_select;
input[12:0] addr;
reg rom_select,ram_select;
always @(addr)
begin
	casex(addr)
		13'b11xxxxxxxxxxx:
			begin
				{rom_select,ram_select}<=2'b01;
			end
		13'b0xxxxxxxxxxxx:
			begin
				{rom_select,ram_select}<=2'b10;
			end
		13'b10xxxxxxxxxxx:
			begin
				{rom_select,ram_select}<=2'b10;
			end
		default:
			begin
				{rom_select,ram_select}<=2'b00;
			end
	endcase
end


endmodule
