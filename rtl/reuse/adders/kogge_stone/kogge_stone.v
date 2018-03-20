module kogge_stone #(parameter WIDTH = 16) (a, b, cin, out, cout, vout); 

  localparam STAGES = $clog2(WIDTH);

  input [WIDTH-1:0] a;
  input [WIDTH-1:0] b;
  input cin;
  output [WIDTH-1:0] out;
  output cout;
  output vout;

  wire [WIDTH-1:0] g[STAGES:0];  
  wire [WIDTH-1:0] p[STAGES:0];  

  //Generating p,g's
  assign p[0][0]=0;
  assign g[0][0]=cin;

  genvar i;
  generate begin : loop_pg 
  for (i=0; i<WIDTH-1; i=i+1) begin
       PG u_pg (a[i], b[i], p[0][i+1], g[0][i+1]);
  end
  end
  endgenerate

  genvar j,k,m; 
  generate begin : stage
  for (i=0; i<STAGES; i=i+1) begin

    //greys
    for(j=0; j< 2**i; j=j+1) begin : l1
      grey u_greys (g[i][0+j], g[i][(2**i)+j], p[i][(2**i)+j], g[i+1][(2**i)+j]);
    end

    //blacks
    for(k=0;k< (WIDTH-(2**(i+1)));k=k+1) begin :l2
      black u_blks (g[i][(2**i)+k], g[i][(2**(i+1))+k], p[i][(2**i)+k], p[i][(2**(i+1))+k], g[i+1][(2**(i+1))+k], p[i+1][(2**(i+1))+k]);
    end

    //buffers
    for(m=0; m<2**i ;m=m+1) begin :l3
      buffer$ u_bg (g[i+1][m], g[i][m]);
      buffer$ u_bp (p[i+1][m], p[i][m]);
    end
  end
  end
  endgenerate

  wire [WIDTH-1:0] cou;
  generate begin : sum
  for (i=0; i< WIDTH; i=i+1) begin
    FA u_fa (a[i],b[i],g[STAGES][i],out[i], cou[i]);
  end
  end
  endgenerate
  
  assign cout = cou[WIDTH-1];

endmodule

module black (
input g0, 
input g1,
input p0, 
input p1,
output g,
output p
);

//g = g1 + g0.p1

wire g0p1_bar, g1_bar;

inv1$  inv1(g1_bar, g1);
nand2$ nand1(g0p1_bar, g0, p1);
nand2$ nand2(g, g1_bar, g0p1_bar);

//p = p0p1
and2$ and1(p, p0, p1);

endmodule

module grey (
input g0, 
input g1,
input p1,
output g
);

//g = g1 + g0.p1

wire g0p1_bar, g1_bar;

inv1$ inv1(g1_bar, g1);
nand2$ nand1(g0p1_bar, g0, p1);
nand2$ nand2(g, g1_bar, g0p1_bar);

endmodule

module PG(
  input a,
  input b,
  output p,
  output g
);
  xor2$ u_p (p, a, b);
  and2$ u_g (g, a, b);

endmodule

