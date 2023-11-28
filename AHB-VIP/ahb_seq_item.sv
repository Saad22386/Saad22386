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

Filename  :	  ahb_seq_item.sv   
Date      :	  25/09/2023
Company   :       IMPARE
Version   :	  0.0 (Basic version)
Webpage   :       https://www.impare.cloud/
Email     :	  info@impare.cloud
Linkedin  :       https://www.linkedin.com/company/imparé/
*********************************************************/
typedef enum bit[1:0] {IDLE,BUZY,NON_SEQ,SEQ} ahb_trans_e;
typedef enum bit[1:0] {BYTE,HALF_WORD,WORD,DOUBLE_WORD} ahb_size_e;
class ahb_seq_item #(parameter AW=16, DW=32) extends uvm_sequence_item;
	rand bit [DW-1:0] hwdata;
	rand bit [AW-1:0] haddr;
	rand ahb_trans_e htrans;
	rand ahb_size_e hsize;
	rand bit hwrite;
	
	bit [DW-1:0] hrdata;
	
	`uvm_object_utils_begin(ahb_seq_item)
	  `uvm_field_int(hwdata,UVM_ALL_ON)
	  `uvm_field_int(haddr,UVM_ALL_ON)
	  `uvm_field_int(hwrite,UVM_ALL_ON)
	  `uvm_field_int(htrans,UVM_ALL_ON)
	  `uvm_field_int(hsize,UVM_ALL_ON)
	`uvm_object_utils_end
	
	constraint addr_c{
	  haddr > 0;
	}
	
	constraint trans_c{
	  htrans inside {IDLE,NON_SEQ};
	}
	
	constraint size_c{
	  hsize inside {BYTE,HALF_WORD,WORD};
	}
	
	constraint hwdata_size {
	  if(hsize==BYTE)
	    hwdata[31:8] == 0;
	  if(hsize==HALF_WORD)
	    hwdata[31:16] == 0;
	    
	  solve hsize before hwdata;
	}
	
 function new(string name ="ahb_seq_item");
	 super.new(name);
 endfunction

endclass
