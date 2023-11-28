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

Filename  :   ahb_monitor.sv   
Date      :   25/09/2023
Company   :   IMPARE
Version   :   0.0 (Basic version)
Webpage   :   https://www.impare.cloud/
Email     :   info@impare.cloud
Linkedin  :   https://www.linkedin.com/company/imparé/
*********************************************************/
class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  virtual interface                    ahb_if vif;
  ahb_seq_item                         trans;
  uvm_analysis_port#(ahb_seq_item)     mon_port;
 
 function new(string name="ahb_monitor",uvm_component parent=null);
   super.new(name,parent);
   mon_port=new("mon_port",this);
 endfunction
 
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db#(virtual ahb_if)::get(this,"","vif",vif))
     `uvm_fatal(get_type_name(),"Didn't get handle to virtual interface vif");
 endfunction
 
 task run_phase(uvm_phase phase);
   super.run_phase(phase);
   wait(vif.HRESETn);
   @(vif.master_moncb);
  
   forever begin
     trans=ahb_seq_item #(16,32)::type_id::create("trans",this);
     @(vif.master_moncb);
  	 if(vif.master_moncb.hwrite)
  	   write_data();
  	 else
  		 read_data();
   end
 endtask
 
 virtual task write_data();
   wait(vif.master_moncb.hready);
   @(vif.master_moncb);
  
   trans.haddr=vif.master_moncb.haddr;
   trans.hwrite=vif.master_moncb.hwrite;
  
   @(vif.master_moncb);
   trans.hwdata=vif.master_moncb.hwdata;
   
   wait(vif.master_moncb.hready);
   @(vif.master_moncb);
 endtask
  
 virtual task read_data();
   wait(vif.master_moncb.hready)
   @(vif.master_moncb);
    
   trans.haddr=vif.master_moncb.haddr;
   trans.hwrite=vif.master_moncb.hwrite;
   
   @(vif.master_moncb);

   wait(vif.master_moncb.hready);
   @(vif.master_moncb); 
   trans.hrdata=vif.master_moncb.hrdata;
   `uvm_info(get_type_name(), $sformatf("hwrite : %b,haddr : %0h,hrdata : %0h",trans.hwrite, trans.haddr,trans.hrdata), UVM_LOW);
   mon_port.write(trans);
 endtask
  
endclass

