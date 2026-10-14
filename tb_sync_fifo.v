
`timescale 1ns / 1ps

module tb_sync_fifo;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] din;

    wire [DATA_WIDTH-1:0] dout;
    wire full;
    wire empty;

    integer i;
    integer errors;

    // Device Under Test (DUT)
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // 100 MHz clock: 10 ns period
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Write one value
    task write_data;
        input [DATA_WIDTH-1:0] data;
        begin
            @(negedge clk);
            din = data;
            wr_en = 1'b1;
            rd_en = 1'b0;

            @(posedge clk);
            #1;

            @(negedge clk);
            wr_en = 1'b0;
        end
    endtask

    // Read one value and check FIFO order
    task read_check;
        input [DATA_WIDTH-1:0] exp_data;
        begin
            @(negedge clk);
            wr_en = 1'b0;
            rd_en = 1'b1;

            @(posedge clk);
            #1;

            if (dout !== exp_data) begin
                $display("ERROR: Expected %h, got %h at time %0t",
                         exp_data, dout, $time);
                errors = errors + 1;
            end else begin
                $display("PASS: Read %h at time %0t", dout, $time);
            end

            @(negedge clk);
            rd_en = 1'b0;
        end
    endtask

    initial begin
        rst = 1'b1;
        wr_en = 1'b0;
        rd_en = 1'b0;
        din = 0;
        errors = 0;

        // Reset test
        repeat (2) @(negedge clk);
        rst = 1'b0;
        @(negedge clk);

        if (empty !== 1'b1) begin
            $display("ERROR: FIFO should be empty after reset");
            errors = errors + 1;
        end else begin
            $display("PASS: FIFO empty after reset");
        end

        // Underflow protection
        rd_en = 1'b1;
        @(posedge clk);
        #1;

        if (empty !== 1'b1) begin
            $display("ERROR: Empty flag incorrect during underflow");
            errors = errors + 1;
        end else begin
            $display("PASS: FIFO prevents underflow");
        end

        @(negedge clk);
        rd_en = 1'b0;

        // Basic write and read test
        write_data(8'hA1);
        write_data(8'hB2);
        write_data(8'hC3);
        write_data(8'hD4);

        read_check(8'hA1);
        read_check(8'hB2);
        read_check(8'hC3);
        read_check(8'hD4);

        if (empty !== 1'b1) begin
            $display("ERROR: FIFO should be empty after reads");
            errors = errors + 1;
        end else begin
            $display("PASS: FIFO empty after reading all data");
        end

        // Fill the FIFO completely
        for (i = 0; i < DEPTH; i = i + 1)
            write_data(i);

        if (full !== 1'b1) begin
            $display("ERROR: FIFO should be full");
            errors = errors + 1;
        end else begin
            $display("PASS: FIFO full at DEPTH entries");
        end

        // Overflow protection: attempt to write while full
        @(negedge clk);
        din = 8'hEE;
        wr_en = 1'b1;
        rd_en = 1'b0;

        @(posedge clk);
        #1;

        if (full !== 1'b1) begin
            $display("ERROR: FIFO full flag lost");
            errors = errors + 1;
        end else begin
            $display("PASS: FIFO remains full after rejected write");
        end

        @(negedge clk);
        wr_en = 1'b0;

        // Verify original data was not corrupted
        for (i = 0; i < DEPTH; i = i + 1)
            read_check(i);

        if (empty !== 1'b1) begin
            $display("ERROR: FIFO should be empty after draining");
            errors = errors + 1;
        end else begin
            $display("PASS: FIFO empty after draining");
        end

        // Pointer wraparound test
        write_data(8'h55);
        write_data(8'h66);

        read_check(8'h55);
        read_check(8'h66);

        // Simultaneous read/write test
        write_data(8'h77);

        @(negedge clk);
        din = 8'h88;
        wr_en = 1'b1;
        rd_en = 1'b1;

        @(posedge clk);
        #1;

        if (dout !== 8'h77) begin
            $display("ERROR: Simultaneous read expected 77, got %h",
                     dout);
            errors = errors + 1;
        end else begin
            $display("PASS: Simultaneous read returned 77");
        end

        @(negedge clk);
        wr_en = 1'b0;
        rd_en = 1'b0;

        // Check the newly written value
        read_check(8'h88);

        // Final result
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTBENCH FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
