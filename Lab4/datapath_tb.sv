/* Microprocessor Datapath Test Bench */

/* Assembly Terms */
// Input | M[0], M[1], M[2], or Cin
// Reg | Registers R[0], R[1], R[2], or A
// Source | Source Register or Source Input
// Dest | Destination Register

/* Assembly Operations ( Name | Code | Operation ) */
// Move | MOV Dest, Source | Dest = Source
// Move All Inputs | MOVM | R0 = M0, R1 = M1, R2 = M2
// Add with Carry | ADC Source | A = A + Source + Cin
// Subtract with Carry | SBC Source | A = A + ~Source + Cin

module datapath_tb();

logic clk, clr_i, cin_i;
logic [3:0] m_i [2:0];
logic [3:0] ce_i;
logic [2:0] w_i;
logic [1:0] sel_i;
logic [2:0] s_i;
logic [3:0] r_q [2:0];
parameter CLK_PERIOD = 20000; // 20000 ps = 20 ns = 50 MHz

datapath uut (.clk(clk), .clr_i(clr_i), .cin_i(cin_i), .m_i(m_i), .ce_i(ce_i), .w_i(w_i), .sel_i(sel_i), .s_i(s_i), .r_q(r_q));

/* Clock */
// To ensure that the rising edge of the clock signal occurs as close to the middle of the input signal as possible:
// All desired inputs should last for one full clock period
// The input signal should only ever rise or fall with the falling edge of the clock signal
initial clk = 1'b0;
always #(CLK_PERIOD / 2) clk = ~clk;

initial begin
  /* Input Data */
  m_i[0] = 4'h3;
  m_i[1] = 4'hA;
  m_i[2] = 4'h0;
  cin_i = 1'b1;

  // ce_i and clr_i must be set in every operation to prevent unintentionally writing to registers not related to the current operation
  /* CLEAR */
  // Operation Outputs
  clr_i = 1'b1;
  ce_i = 4'b0000;
  w_i = 3'b000;
  sel_i = 2'b00;
  s_i = 3'b000;
  #(CLK_PERIOD);

  /* MOV RX, MX */
  // Operation Outputs
  clr_i = 1'b0;
  ce_i = 4'b0111; // Enable dff[2:0]
  w_i = 3'b000; // dff[2:0] = M[2:0]
  // Don't Cares
  sel_i = 2'b00;
  s_i = 3'b000;
  #(CLK_PERIOD);

  /* MOV A, R0 */
  // Operation Outputs
  clr_i = 1'b0;
  ce_i = 4'b1000; // Enable dff[3]
  sel_i = 2'b00; // Set B to R0
  s_i = 3'b010; // PASS B
  // Don't Cares
  w_i = 3'b000;
  #(CLK_PERIOD);

  /* SBC R1 */
  // Operation Outputs
  clr_i = 1'b0;
  ce_i = 4'b1000; // Enable dff[3]
  sel_i = 2'b01; // Set B to R1
  s_i = 3'b001; // A + ~B + Cin
  // Don't Cares
  w_i = 3'b000;
  #(CLK_PERIOD);

  /* MOV R2, A */
  // Operation Outputs
  clr_i = 1'b0;
  ce_i = 4'b0100; // Enable dff[2]
  w_i = 3'b100; // dff[2:0] = {A, M[1:0]}
  // Don't Cares
  sel_i = 2'b00;
  s_i = 3'b000;
  #(CLK_PERIOD);

  /* IDLE */
  // Operation Outputs
  clr_i = 1'b0;
  ce_i = 4'b0000;
  w_i = 3'b000;
  sel_i = 2'b00;
  s_i = 3'b000;
  #(CLK_PERIOD);

  $stop; // Suspend simulation
end

endmodule
