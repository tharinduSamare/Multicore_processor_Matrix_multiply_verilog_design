`timescale 1ns/1ps

module controlUnit_tb ();

localparam CLK_PERIOD = 20;
reg clk;
initial begin
    clk <= 0;
    forever begin
        #(CLK_PERIOD/2);
        clk <= ~clk;
    end
end

localparam INS_WIDTH = 8;

reg rstN,start,Zout;
reg [INS_WIDTH-1:0] ins;
wire [2:0] aluOp;
wire [3:0] incReg;    // {PC, RC, RP, RQ}
wire [9:0] wrEnReg;   // {AR, R, PC, IR, RL, RC, RP, RQ, R1, AC}
wire [3:0] busSel;
wire DataMemWrEn,ZWrEn;
wire done,ready;

localparam [INS_WIDTH-1:0]
    NOP 	    =   8'd0,
    ENDOP       =	8'd1,
    CLAC        =	8'd2,
    LDIAC       =	8'd3,
    LDAC        =	8'd4,
    STR         =	8'd5,
    STIR        =	8'd6,
    JUMP        =	8'd7,
    JMPNZ       =	8'd8,
    JMPZ        =	8'd9,
    MUL	        =   8'd10,
    ADD	        =   8'd11,
    SUB	        =   8'd12,
    INCAC	    =   8'd13,
    MV_RL_AC    =	{4'd1,4'd15},
    MV_RP_AC    =	{4'd2,4'd15},
    MV_RQ_AC    =	{4'd3,4'd15},
    MV_RC_AC    =	{4'd4,4'd15},
    MV_R_AC     =	{4'd5,4'd15},
    MV_R1_AC    =	{4'd6,4'd15},
    MV_AC_RP    =	{4'd7,4'd15},
    MV_AC_RQ    =	{4'd8,4'd15},
    MV_AC_RL    =	{4'd9,4'd15};

localparam [31:0]// time duration for each instruction to exicute
        NOP_time_duration 	    =   4,
        ENDOP_time_duration     =   4,
        CLAC_time_duration      =   4,
        LDIAC_time_duration     =   8,
        LDAC_time_duration      =   6,
        STR_time_duration       =   6,
        STIR_time_duration      =   8,
        JUMP_time_duration      =   6,
        JMPNZ_Y_time_duration   =   6,
        JMPNZ_N_time_duration   =   4,
        JMPZ_Y_time_duration    =   6,
        JMPZ_N_time_duration    =   4,
        MUL_time_duration	    =   4,
        ADD_time_duration	    =   4,
        SUB_time_duration	    =   4,
        INCAC_time_duration	    =   4,
        MV_RL_AC_time_duration  =   4,
        MV_RP_AC_time_duration  =   4,
        MV_RQ_AC_time_duration  =   4,
        MV_RC_AC_time_duration  =   4,
        MV_R_AC_time_duration   =   4,
        MV_R1_AC_time_duration  =   4,
        MV_AC_RP_time_duration  =   4,
        MV_AC_RQ_time_duration  =   4,
        MV_AC_RL_time_duration  =   4;


controlUnit #(.INS_WIDTH(INS_WIDTH)) dut(.clk(clk), .rstN(rstN), .start(start),
            .Zout(Zout), .ins(ins), .aluOp(aluOp), .incReg(incReg), .wrEnReg(wrEnReg),
            .busSel(busSel), .DataMemWrEn(DataMemWrEn), .ZWrEn(ZWrEn), 
            .done(done), .ready(ready));

////////// for easy readability (start) //////////////



task automatic test_instruction(
    input [31:0] duration,
    input Z_value,
    input [INS_WIDTH-1:0] instruction    
); begin
    
    @(posedge clk);
    ins <= instruction;
    Zout <= Z_value;

    #(duration * CLK_PERIOD);
    // repeat(duration)@(posedge clk);
end

endtask


initial begin
    @(posedge clk);
    rstN <= 1'b0;
    @(posedge clk);
    rstN <= 1'b1;
    start <= 1'b0;
    @(posedge clk);
    start <= 1'b1;

    ////// test NOP
    test_instruction(NOP_time_duration, 1'bX, NOP);

    ///// test CLAC
    test_instruction(CLAC_time_duration, 1'bX, CLAC);

    ///// test LDIAC
    test_instruction(LDIAC_time_duration, 1'bX, LDIAC);

    ////// test LDAC
    test_instruction(LDAC_time_duration, 1'bX, LDAC);

    ////// test STR
    test_instruction(STR_time_duration, 1'bX, STR);

    ////// test STIR
    test_instruction(STIR_time_duration, 1'bX, STIR);

    ////// test JUMP
    test_instruction(JUMP_time_duration, 1'bX, JUMP);

    ////// test JMPNZ_Y
    test_instruction(JMPNZ_Y_time_duration, 1'b0, JMPNZ);

    ////// test JMPNZ_N
    test_instruction(JMPNZ_N_time_duration, 1'b1, JMPNZ);

    ////// test JMPZ_Y
    test_instruction(JMPZ_Y_time_duration, 1'b1, JMPZ);

    ////// test JMPZ_N
    test_instruction(JMPZ_N_time_duration, 1'b0, JMPZ);

    ////// test MUL
    test_instruction(MUL_time_duration, 1'b0, MUL);

    ////// test ADD
    test_instruction(ADD_time_duration, 1'b0, ADD);

    ////// test SUB
    test_instruction(SUB_time_duration, 1'b0, SUB);

    ////// test INCAC
    test_instruction(INCAC_time_duration, 1'b0, INCAC);

    ////// test MV_RL_AC
    test_instruction(MV_RL_AC_time_duration, 1'b0, MV_RL_AC);

    ////// test MV_RP_AC
    test_instruction(MV_RP_AC_time_duration, 1'b0, MV_RP_AC);

    //// test MV_RQ_AC
    test_instruction(MV_RQ_AC_time_duration, 1'b0, MV_RQ_AC);

    ////// test MV_RC_AC
    test_instruction(MV_RC_AC_time_duration, 1'b0, MV_RC_AC);

    ////// test MV_R_AC
    test_instruction(MV_R_AC_time_duration, 1'b0, MV_R_AC);

    ////// test MV_R1_AC
    test_instruction(MV_R1_AC_time_duration, 1'b0, MV_R1_AC);

    ////// test MV_AC_RP
    test_instruction(MV_AC_RP_time_duration, 1'b0, MV_AC_RP);

    ////// test MV_AC_RQ
    test_instruction(MV_AC_RQ_time_duration, 1'b0, MV_AC_RQ);

    ////// test MV_AC_RL
    test_instruction(MV_AC_RL_time_duration, 1'b0, MV_AC_RL);

    ///// test ENDOP
    test_instruction(ENDOP_time_duration, 1'bX, ENDOP);

end

initial begin         // simulation stop condition
    forever begin
        @(posedge clk);
        if (done) begin
            #(5*CLK_PERIOD);
            $stop;
        end
    end

    // repeat(100) @(posedge clk);
    // $stop;
end

endmodule : controlUnit_tb

// module controlUnit_tb();

// reg clk,rd,wr,ce;
// reg [7:0]  addr,data_wr,data_rd;
// reg [7:0]  read_data;

// initial begin
//   clk = 0;
//   read_data = 0;
//   rd = 0;
//   wr = 0;
//   ce = 0;
//   addr = 0;
//   data_wr = 0;
//   data_rd = 0;
//   // Call the write and read tasks here
//   #1 cpu_write(8'h11,8'hAA);
//   #1 cpu_read(8'h11,read_data);
//   #1 cpu_write(8'h12,8'hAB);
//   #1 cpu_read(8'h12,read_data);
//   #1 cpu_write(8'h13,8'h0A);
//   #1 cpu_read(8'h13,read_data);
//   #100 $stop;
// end
// // Clock Generator
// always
//   #1 clk = ~clk;
// // CPU Read Task
// task cpu_read (input [7:0]  address, output [7:0] data);
//   begin
//     // $display ("%g CPU Read  task with address : %h", $time, address);
//     // $display ("%g  -> Driving CE, RD and ADDRESS on to bus", $time);
//     @ (posedge clk);
//     addr <= address;
//     ce <= 1;
//     rd <= 1;
//     @ (negedge clk);
//     data <= data_rd;
//     @ (posedge clk);
//     addr <= 0;
//     ce <= 0;
//     rd <= 0;
//     $display ("%g CPU Read  data              : %h", $time, data);
//     $display ("======================");
//   end
// endtask
// // CU Write Task
// task cpu_write(input [7:0]  address, input [7:0] data);
//   begin
//     $display ("%g CPU Write task with address : %h Data : %h", 
//       $time, address,data);
//     $display ("%g  -> Driving CE, WR, WR data and ADDRESS on to bus", 
//       $time);
//     @ (posedge clk);
//     addr = address;
//     ce = 1;
//     wr = 1;
//     data_wr = data;
//     @ (posedge clk);
//     addr = 0;
//     ce = 0;
//     wr = 0;
//     $display ("======================");
//   end
// endtask

// // Memory model for checking tasks
// reg [7:0] mem [0:255];

// always @ (addr or ce or rd or wr or data_wr)
// if (ce) begin
//   if (wr) begin
//     mem[addr] = data_wr;
//   end
//   if (rd) begin
//     data_rd = mem[addr];
//   end
// end

// endmodule