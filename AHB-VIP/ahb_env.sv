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

Filename  :   ahb_env.sv   
Date      :   25/09/2023
Company   :   IMPARE
Version   :   0.0 (Basic version)
Webpage   :   https://www.impare.cloud/
Email     :   info@impare.cloud
Linkedin  :   https://www.linkedin.com/company/imparé/
*********************************************************/
class ahb_env extends uvm_env;
 `uvm_component_utils (ahb_env);
  
 ahb_coverage m_cov;
 ahb_agent    m_agent;
 
 function new(string name="ahb_env", uvm_component parent);
   super.new (name, parent);
 endfunction

 virtual function void build_phase(uvm_phase phase);       
   super.build_phase(phase);
   m_agent = ahb_agent::type_id::create("m_agent", this);
   m_cov = ahb_coverage#(16,32)::type_id::create("m_cov", this);
 endfunction

 virtual function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   m_agent.m_monitor.mon_port.connect (m_cov.analysis_export);
 endfunction
endclass
