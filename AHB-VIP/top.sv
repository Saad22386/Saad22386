/********************************************************
Copyright @2023 Impare Technologies inc.
Licensed under the Apache License, Version 2.0
SPDX-License-Identifier: Apache-2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Filename  :   test.sv   
Date      :   25/09/2023
Company   :   IMPARE
Version   :   0.0 (Basic version)
Webpage   :   https://www.impare.cloud/
Email     :   info@impare.cloud
Linkedin  :   https://www.linkedin.com/company/imparé/
**********************************************************/
import uvm_pkg::*;
`include "uvm_macros.svh"
module tb_top;
 bit clk;
 bit rst;
 
  ahb_if vif(clk,rst);
  ahb_model model;

 initial begin
   rst=0;
   #20 rst=1'b1;
 end

 always #5 clk=~clk;
 
 initial begin
  	uvm_config_db#(virtual ahb_if)::set(null, "", "vif",vif);
 end

 initial begin
 	 run_test("ahb_test");
 end
 
 initial begin
   model=new(vif);
   model.run();
 end

endmodule
