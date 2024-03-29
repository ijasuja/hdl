# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create axi_dmac
adi_ip_files axi_dmac [list \
  "$ad_hdl_dir/library/common/sync_bits.v" \
  "$ad_hdl_dir/library/common/sync_gray.v" \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/axi_fifo/axi_fifo.v" \
  "$ad_hdl_dir/library/axi_fifo/address_gray.v" \
  "$ad_hdl_dir/library/axi_fifo/address_gray_pipelined.v" \
  "address_generator.v" \
  "data_mover.v" \
  "request_arb.v" \
  "request_generator.v" \
  "response_handler.v" \
  "axi_register_slice.v" \
  "2d_transfer.v" \
  "dest_axi_mm.v" \
  "dest_axi_stream.v" \
  "dest_fifo_inf.v" \
  "src_axi_mm.v" \
  "src_axi_stream.v" \
  "src_fifo_inf.v" \
  "splitter.v" \
  "response_generator.v" \
  "axi_dmac.v" \
  "axi_repack.v" ]

adi_ip_properties axi_dmac

set_property physical_name {s_axi_aclk} [ipx::get_port_map CLK \
  [ipx::get_bus_interface s_axi_signal_clock [ipx::current_core]]]

adi_add_bus "s_axis" "axis" "slave" \
	[list {"s_axis_aclk" "ACLK"} \
	  {"s_axis_ready" "TREADY"} \
	  {"s_axis_valid" "VALID"} \
	  {"s_axis_data" "TDATA"} \
	  {"s_axis_user" "TUSER"} ]

adi_add_bus "m_axis" "axis" "master" \
	[list {"m_axis_aclk" "ACLK"} \
	  {"m_axis_ready" "TREADY"} \
	  {"m_axis_valid" "VALID"} \
	  {"m_axis_data" "TDATA"} ]
   
adi_set_bus_dependency "m_src_axi" "m_src_axi" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_SRC')) = 0)"
adi_set_bus_dependency "m_dest_axi" "m_dest_axi" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_DEST')) = 0)"
adi_set_bus_dependency "s_axis" "s_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_SRC')) = 1)"
adi_set_bus_dependency "m_axis" "m_axis" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_DEST')) = 1)"
adi_set_ports_dependency "fifo_wr" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_SRC')) = 2)"
adi_set_ports_dependency "fifo_rd" \
	"(spirit:decode(id('MODELPARAM_VALUE.C_DMA_TYPE_DEST')) = 2)"

ipx::add_bus_interface {fifo_wr} [ipx::current_core]
set_property abstraction_type_vlnv {xilinx.com:interface:fifo_write_rtl:1.0} [ipx::get_bus_interface fifo_wr [ipx::current_core]]
set_property bus_type_vlnv {xilinx.com:interface:fifo_write:1.0} [ipx::get_bus_interface fifo_wr [ipx::current_core]]
set_property display_name {fifo_wr} [ipx::get_bus_interface fifo_wr [ipx::current_core]]

ipx::add_port_map {WR_DATA} [ipx::get_bus_interface fifo_wr [ipx::current_core]]
set_property physical_name {fifo_wr_din} [ipx::get_port_map WR_DATA [ipx::get_bus_interface fifo_wr [ipx::current_core]]]
ipx::add_port_map {WR_EN} [ipx::get_bus_interface fifo_wr [ipx::current_core]]
set_property physical_name {fifo_wr_en} [ipx::get_port_map WR_EN [ipx::get_bus_interface fifo_wr [ipx::current_core]]]

ipx::add_bus_interface {fifo_wr_clock} [ipx::current_core]
set_property abstraction_type_vlnv {xilinx.com:signal:clock_rtl:1.0} [ipx::get_bus_interface fifo_wr_clock [ipx::current_core]]
set_property bus_type_vlnv {xilinx.com:signal:clock:1.0} [ipx::get_bus_interface fifo_wr_clock [ipx::current_core]]
set_property display_name {fifo_wr_clock} [ipx::get_bus_interface fifo_wr_clock [ipx::current_core]]
ipx::add_port_map {CLK} [ipx::get_bus_interface fifo_wr_clock [ipx::current_core]]
set_property physical_name {fifo_wr_clk} [ipx::get_port_map CLK [ipx::get_bus_interface fifo_wr_clock [ipx::current_core]]]

ipx::add_bus_parameter {ASSOCIATED_BUSIF} [ipx::get_bus_interface fifo_wr_clock [ipx::current_core]]
set_property value {fifo_wr} [ipx::get_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interface fifo_wr_clock [ipx::current_core]]]

ipx::save_core [ipx::current_core]

