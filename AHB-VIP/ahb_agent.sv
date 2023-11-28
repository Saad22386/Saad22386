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

Filename  :   ahb_agent.sv   
Date      :   25/09/2023
Company   :   IMPARE
Version   :   0.0 (Basic version)
Webpage   :   https://www.impare.cloud/
Email     :   info@impare.cloud
Linkedin  :   https://www.linkedin.com/company/imparé/
*********************************************************/
class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)
 
  virtual interface        ahb_if vif;
  ahb_sequencer            m_sequencer;
  ahb_driver               m_driver;
  ahb_monitor              m_monitor;
 
 function new(string name="ahb_agent",uvm_component parent=null);
   super.new(name,parent);
 endfunction
 
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_sequencer=ahb_sequencer::type_id::create("m_sequencer",this);
   m_driver=ahb_driver::type_id::create("m_driver",this);
   m_monitor=ahb_monitor::type_id::create("m_monitor",this);
 endfunction
 
 function void connect_phase(uvm_phase phase);
   if(get_is_active()==UVM_ACTIVE) begin
     m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
   end
 endfunction
endclass
