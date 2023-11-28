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

Filename  :	ahb_coverage.sv   
Date      :	25/09/2023
Company   :     IMPARE
Version   :	0.0 (Basic version)
Webpage   :     https://www.impare.cloud/
Email     :     info@impare.cloud
Linkedin  :     https://www.linkedin.com/company/imparé/
*********************************************************/
virtual class uvm_subscriber #(type T=int) extends uvm_component;
 typedef uvm_subscriber #(T) this_type;
 
 uvm_analysis_imp #(T, this_type) analysis_export;
 
   function new(string name,uvm_component parent);
     super.new(name,parent);
     analysis_export=new("analysis_export",this);
    endfunction
    
    pure virtual function void write(T item);
endclass

class ahb_coverage #(parameter AW=16, DW=32) extends uvm_subscriber #(ahb_seq_item);
	`uvm_component_utils (ahb_coverage);

  virtual interface  ahb_if vif;
  ahb_seq_item       trans;
	
  function new(string name="ahb_coverage", uvm_component parent);
    super.new (name, parent);
    ahb_covergroup = new();
  endfunction
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    trans=ahb_seq_item#(16,32)::type_id::create("trans",this);
    if(!uvm_config_db#(virtual ahb_if)::get(this,"","vif",vif))
      `uvm_fatal(get_type_name(),"Didn't get handle to virtual interface vif");
  endfunction
	
  covergroup ahb_covergroup;
    
    cg1: coverpoint trans.hsize{
      bins size = {BYTE, HALF_WORD, WORD} ;
      ignore_bins bad = {DOUBLE_WORD};
    }
      
    cg2: coverpoint trans.htrans{
      bins trans = {IDLE, NON_SEQ};
      ignore_bins bad = {BUZY, SEQ};
    }
      
    cg3: coverpoint trans.hwrite{
      bins rw = {[0:1]} ;
    }
      
    hsizexhtrans  : cross cg1,cg2;
    hsizexhwrite  : cross cg1,cg3;
    hwritexhtrans : cross cg3,cg2;
      
  endgroup
     
     
  function void write(ahb_seq_item item);
    trans = item;
  endfunction
   
  function void report_phase(uvm_phase phase) ;
    super.report_phase(phase) ;
    `uvm_info(get_type_name(),$sformatf("overall coverage = %0f", $get_coverage()),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("coverage of covergroup ahb_covergroup = %0f", ahb_covergroup.get_coverage()),UVM_LOW);
  endfunction
     
  task run_phase(uvm_phase phase);
    ahb_covergroup.sample();
    analysis_export.write(trans);
  endtask 
endclass
