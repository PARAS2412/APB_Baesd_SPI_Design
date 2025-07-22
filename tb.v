
module top_module_tb;

    // Testbench signals
    reg PCLK, PRESETn;
    reg [2:0] PADDR;
    reg PWRITE, PSEL, PENABLE;
    reg [7:0] PWDATA;
    reg miso;

    wire ss, sclk, spi_interrupt_request, mosi;
    wire [7:0] PRDATA;
    wire PREADY, PSLVERR;

    // Instantiate the top module
    top_module uut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWDATA(PWDATA),
        .miso(miso),
        .ss(ss),
        .sclk(sclk),
        .spi_interrupt_request(spi_interrupt_request),
        .mosi(mosi),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );

    // Clock generation
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK; // 100MHz Clock
    end

    // Test sequence
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        // Initial reset
        PRESETn = 0;
        PSEL = 0; PENABLE = 0; PWRITE = 0; PADDR = 0; PWDATA = 0; miso = 0;
        #20;
        PRESETn = 1;
	PSEL = 1; PENABLE = 1; PWRITE =1;
        // Write SPI_CR_1 (control reg 1) - enable SPI, set as master
        apb_write(3'b000, 8'b01010101); // spe=1, mstr=1, sptie/spie set arbitrarily
        #20;

        // Write SPI_CR_2 (control reg 2) - modfen = 1
        apb_write(3'b001, 8'b00010000);
        #20;

        // Write SPI_BR (baud rate register)
        apb_write(3'b010, 8'b00010001); // sppr=001, spr=001
        #20;

        // Write data to SPI_DR (start transmission)
        apb_write(3'b101, 8'b10101010); // MOSI = 0xAA
        #200;

        // Simulate MISO data from slave
        miso = 1'b1;
        #200;
        miso = 1'b0;
        
		  #200;
        // Read SPI_DR (receive completed data)
        apb_read(3'b100); // Should give received data
        #50;

        // End simulation
        #500 $finish;
    end

    // APB write task
    task apb_write(input [2:0] addr, input [7:0] data);
        begin
            @(posedge PCLK);
            PADDR = addr;
            PWDATA = data;
        end
    endtask

    // APB read task
    task apb_read(input [2:0] addr);
        begin
            @(posedge PCLK);
            PADDR = addr;
            PWRITE = 0;
            $display("Read from address %0h = %0h", addr, PRDATA);
        end
    endtask

endmodule
