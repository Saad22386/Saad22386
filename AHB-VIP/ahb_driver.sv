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

Filename  :   ahb_driver.sv  
Date      :   25/09/2023
Company   :   IMPARE
Version   :   0.0 (Basic version)
Webpage   :   https://www.impare.cloud/
Email     :   info@impare.cloud
Linkedin  :   https://www.linkedin.com/company/imparé/
*********************************************************/
class ahb_driver extends uvm_driver #(ahb_seq_item);
  `uvm_component_utils(ahb_driver);

  virtual interface  ahb_if vif;
  ahb_seq_item       trans;
  
 
 function new(string name="ahb_driver",uvm_component parent=null);
   super.new(name,parent);
 endfunction
 
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   trans=ahb_seq_item#(16,32)::type_id::create("trans",this);
   if(!uvm_config_db#(virtual ahb_if)::get(this,"","vif",vif))
     `uvm_fatal(get_type_name(),"Didn't get handle to virtual interface vif");
 endfunction
 
 virtual task run_phase(uvm_phase phase);
   super.run_phase(phase);
  
   if(!vif.HRESETn) begin
     vif.hburst=0;
     vif.htrans=0;
     vif.hsize=0;
     vif.hselect=0;
     vif.hresp=0;
     vif.hwdata=0;
     vif.haddr=0;
     vif.hrdata=0;
     vif.hwrite=0;
   end
  
  wait(vif.HRESETn);
  @(vif.master_drvcb);
  
  forever begin
    seq_item_port.get_next_item(trans);
    
    if(trans.htrans != IDLE) begin
      @(vif.master_drvcb);
      if(trans.hwrite)
        write();
      else
        read();
    end
    seq_item_port.item_done();
  end
 endtask
 
 virtual task write();
   wait(vif.master_drvcb.hready);
   @(vif.master_drvcb);
  
   vif.master_drvcb.haddr<=trans.haddr;
   vif.master_drvcb.hwrite<=trans.hwrite;
   vif.master_drvcb.htrans<=trans.htrans;
   vif.master_drvcb.hsize<=trans.hsize;
  
   @(vif.master_drvcb);
   
   vif.master_drvcb.hwdata<=trans.hwdata;
  
   wait(vif.master_drvcb.hready);
   @(vif.master_drvcb);
   `uvm_info(get_type_name(), $sformatf("htrans : %s,hwrite : %b,haddr : %0h,hwdata : %0h",trans.htrans.name(),trans.hwrite, trans.haddr,trans.hwdata), UVM_LOW);
 endtask
 
 virtual task read();
   wait(vif.master_drvcb.hready)
   @(vif.master_drvcb);
  
   vif.master_drvcb.haddr<=trans.haddr;
   vif.master_drvcb.hwrite<=trans.hwrite;
   vif.master_drvcb.htrans<=trans.htrans;
   vif.master_drvcb.hsize<=trans.hsize;
  
   @(vif.master_drvcb);
  
   wait(vif.master_drvcb.hready);
   @(vif.master_drvcb);
   trans.hrdata=vif.master_drvcb.hrdata;    
 endtask
endclass
