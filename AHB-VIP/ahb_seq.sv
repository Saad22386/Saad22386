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

Filename  :	ahb_seq.sv   
Date      :	08/09/2023
Company   :     IMPARE
Version   :	0.0 (Basic version)
Webpage   :     https://www.impare.cloud/
Email     :     info@impare.cloud
Linkedin  :     https://www.linkedin.com/company/imparé/
*********************************************************/
class ahb_base_seq extends uvm_sequence#(ahb_seq_item);
 `uvm_object_utils(ahb_base_seq)
 
 function new(string name="ahb_base_seq");
   super.new(name);
 endfunction
 
  
 task body();
   repeat($urandom_range(10,50)) begin
     req=ahb_seq_item #(16,32)::type_id::create("req");
     start_item(req);
     assert(req.randomize());
     finish_item(req);
   end
 endtask
endclass


class ahb_write_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_write_seq)
 
 function new(string name="ahb_write_seq");
   super.new(name);
 endfunction
 
 task body();
   `uvm_info(get_type_name(),"\t Write random",UVM_LOW);
   repeat($urandom_range(10,50)) begin
     req=ahb_seq_item #(16,32)::type_id::create("req");
     start_item(req);
     assert(req.randomize() with {req.hwrite==1'b1; })
     finish_item(req);
   end
 endtask
endclass


class ahb_write_32_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_write_32_seq)

 function new(string name="ahb_write_32_seq");
   super.new(name);
 endfunction
 
 virtual task body();
   `uvm_info(get_type_name(),"\t Write 32 bit data",UVM_LOW);
    repeat($urandom_range(10,50)) begin
      req=ahb_seq_item #(16,32)::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {	
	      req.hwrite==1'b1;
	      req.hsize == WORD;
     });
     finish_item(req);
     end
 endtask 
endclass


class ahb_write_16_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_write_16_seq)

 function new(string name="ahb_write_16_seq");
   super.new(name);
 endfunction
 
 virtual task body();
  `uvm_info(get_type_name(),"\t Write 16 bit data",UVM_LOW);
   repeat($urandom_range(10,50)) begin
     req=ahb_seq_item #(16,32)::type_id::create("req");
     start_item(req);
     assert(req.randomize() with {	
       req.hwrite==1'b1;
	     req.hsize == HALF_WORD;
     });
     finish_item(req);
   end
  endtask 
endclass
 
class ahb_write_8_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_write_8_seq)

 function new(string name="ahb_write_8_seq");
   super.new(name);
 endfunction
 
 virtual task body();
   `uvm_info(get_type_name(),"\t Write 8 bit data",UVM_LOW);
    repeat($urandom_range(10,50)) begin
      req=ahb_seq_item #(16,32)::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {	
        req.hwrite==1'b1;
	      req.hsize == BYTE;
     });
     finish_item(req);
   end
  endtask
endclass


class ahb_read_32_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_read_32_seq)

 function new(string name="ahb_read_32_seq");
   super.new(name);
 endfunction
 
 virtual task body();
   `uvm_info(get_type_name(),"\t read 32 bit data",UVM_LOW);
    repeat($urandom_range(10,50)) begin
      req=ahb_seq_item #(16,32)::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {	
	      req.hwrite==1'b0;
	      req.hsize == WORD;
     });
     finish_item(req);
     end
 endtask 
endclass


class ahb_read_16_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_read_16_seq)

 function new(string name="ahb_read_16_seq");
   super.new(name);
 endfunction
 
 virtual task body();
  `uvm_info(get_type_name(),"\t read 16 bit data",UVM_LOW);
   repeat($urandom_range(10,50)) begin
     req=ahb_seq_item #(16,32)::type_id::create("req");
     start_item(req);
     assert(req.randomize() with {	
       req.hwrite==1'b0;
	     req.hsize == HALF_WORD;
     });
     finish_item(req);
   end
  endtask 
endclass
 
class ahb_read_8_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_read_8_seq)

 function new(string name="ahb_read_8_seq");
   super.new(name);
 endfunction
 
 virtual task body();
   `uvm_info(get_type_name(),"\t read 8 bit data",UVM_LOW);
    repeat($urandom_range(10,50)) begin
      req=ahb_seq_item #(16,32)::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {	
        req.hwrite==1'b1;
	      req.hsize == BYTE;
     });
     finish_item(req);
   end
  endtask
endclass
 
class ahb_read_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_read_seq)
 
 function new(string name="ahb_read_seq");
   super.new(name);
 endfunction
 
 task body();
   `uvm_info(get_type_name(),"\t Read random",UVM_LOW);
   repeat($urandom_range(10,50)) begin
     req=ahb_seq_item #(16,32)::type_id::create("req");
     start_item(req);
     assert(req.randomize() with {req.hwrite==1'b0; });
     finish_item(req);
   end
 endtask
endclass

class ahb_write_at_specific_address_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_write_at_specific_address_seq)
 
 function new(string name="ahb_write_at_specific_address_seq");
   super.new(name);
 endfunction
 
 virtual task body();
   `uvm_info(get_type_name(),"\t ahb write at specific address",UVM_LOW);
   repeat(2) begin
     req=ahb_seq_item #(16,32)::type_id::create("req");
     start_item(req);
     assert(req.randomize() with {
       req.hwrite==1'b1;
       req.haddr==16'h5923; 
     });
     finish_item(req);
     end
  endtask
endclass
 
class ahb_read_from_specific_address_seq extends ahb_base_seq;
 `uvm_object_utils(ahb_read_from_specific_address_seq)
 
 function new(string name="ahb_read_from_specific_address_seq");
   super.new(name);
 endfunction
 
 virtual task body();
   `uvm_info(get_type_name(),"\t ahb read from specific address",UVM_LOW);
    req=ahb_seq_item #(16,32)::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      req.hwrite==1'b0;
      req.haddr==16'h5923;
      });
    finish_item(req);
 endtask

endclass
