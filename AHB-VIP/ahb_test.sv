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

Filename  :   ahb_test.sv   
Date      :   25/09/2023
Company   :   IMPARE
Version   :   0.0 (Basic version)
Webpage   :   https://www.impare.cloud/
Email     :   info@impare.cloud
Linkedin  :   https://www.linkedin.com/company/imparé/
************************************************************/
class ahb_test extends uvm_test;
  `uvm_component_utils(ahb_test)
  
   ahb_env                             m_env;
   ahb_base_seq                        m_base_seq;
   ahb_write_seq                       m_write_seq;
   ahb_write_32_seq                    m_write_32_seq;
   ahb_read_32_seq                     m_read_32_seq;
   ahb_read_seq                        m_read_seq;
   ahb_write_at_specific_address_seq   m_write_sa;
   ahb_read_from_specific_address_seq  m_read_sa;
   ahb_coverage                        cov;
   
 function new(string name = "ahb_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_env=ahb_env::type_id::create("m_env",this);
   m_base_seq=ahb_base_seq::type_id::create("m_base_seq",this);
   m_write_seq=ahb_write_seq::type_id::create("m_write_seq",this);
   m_write_32_seq=ahb_write_32_seq::type_id::create("m_write_32_seq",this);
   m_read_32_seq=ahb_read_32_seq::type_id::create("m_read_32_seq",this);
   m_read_seq=ahb_read_seq::type_id::create("m_read_seq",this);
   m_write_sa=ahb_write_at_specific_address_seq::type_id::create("m_write_sa",this);
   m_read_sa=ahb_read_from_specific_address_seq::type_id::create("m_read_sa",this);
   cov=ahb_coverage#(16,32)::type_id::create("cov",this);
 endfunction
  
 
 task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   m_base_seq.start(m_env.m_agent.m_sequencer);
   m_write_seq.start(m_env.m_agent.m_sequencer);
   m_write_sa.start(m_env.m_agent.m_sequencer);
   m_read_seq.start(m_env.m_agent.m_sequencer);
   m_read_sa.start(m_env.m_agent.m_sequencer); 
   m_write_32_seq.start(m_env.m_agent.m_sequencer);
   m_read_32_seq.start(m_env.m_agent.m_sequencer);
   phase.drop_objection(this);
 endtask
 
endclass
