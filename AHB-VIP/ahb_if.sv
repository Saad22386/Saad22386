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

Filename  :	ahb_if.sv   
Date      :	25/09/2023
Company   :     IMPARE
Version   :	0.0 (Basic version)
Webpage   :     https://www.impare.cloud/
Email     :     info@impare.cloud
Linkedin  :     https://www.linkedin.com/company/imparé/
*********************************************************/
interface ahb_if #(parameter AW=16, DW=32)(input HCLK, input HRESETn);
	logic hwrite;
	logic [DW-1:0] hwdata;
	logic [DW-1:0] hrdata;
	logic [2:0] hburst;
	logic [1:0] hresp;
	logic [1:0] htrans;
	logic [AW-1:0] haddr;
	logic hready;
	logic [2:0] hsize;
	logic hselect;
	
clocking master_drvcb @(posedge HCLK);
	default input #1ns output #1ns;
	input hready;
	input hresp;
	input hrdata;
	output hwrite;
	output hburst;
	output htrans;
	output haddr;
	output hsize;
  output hwdata;
endclocking

clocking master_moncb @(posedge HCLK);
	default input #1ns output #1ns;
	input hready;
	input hresp;
	input hrdata;
	input hwrite;
	input hburst;
	input htrans;
	input haddr;
	input hsize;
  input hwdata;
endclocking


clocking slave_cb @(posedge HCLK);
	default input #1ns output #1ns;
	output hready;
	output hresp;
	output hrdata;
	input hwrite;
	input hburst;
	input htrans;
	input haddr;
	input hsize;
	input hselect;
  input hwdata;
endclocking

endinterface
