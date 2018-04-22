# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Sun Apr 22 14:35:40 2018
# Designs open: 1
#   V1: tb.vpd
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Schematic.1: .
#   Source.1: testbench.u_system.u_cpu
#   Wave.1: 55 signals
#   Group count = 6
#   Group Fetch signal count = 8
#   Group Decode signal count = 6
#   Group AG signal count = 8
#   Group R signal count = 10
#   Group EX signal count = 9
#   Group Group6 signal count = 14
# End_DVE_Session_Save_Info

# DVE version: K-2015.09-SP1_Full64
# DVE build date: Nov 24 2015 21:15:24


#<Session mode="Full" path="/home/ecelrc/students/mgontala/uarch/uarch_project/tb/main_tb/mads.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state maximized -rect {{0 53} {1279 638}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 300]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 300
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 299} {height 359} {dock_state left} {dock_on_new_line true} {child_hier_colhier 238} {child_hier_coltype 36} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 347]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 347
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 312
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 346} {height 359} {dock_state left} {dock_on_new_line true} {child_data_colvariable 208} {child_data_colvalue 44} {child_data_coltype 68} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 132]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value -1
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 132
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 223} {height 131} {dock_state bottom} {dock_on_new_line true}}
set DriverLoad.1 [gui_create_window -type DriverLoad -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line false -dock_extent 132]
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_width -value_type integer -value 150
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_height -value_type integer -value 132
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DriverLoad.1} {{left 0} {top 0} {width 1055} {height 131} {dock_state bottom} {dock_on_new_line false}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
gui_use_schematics
set Schematic.1 [gui_create_window -type {Schematic}  -parent ${TopLevel.1} -defer_create_taskbar_icon]
set setting [::Misc::Setting::create -array DvePathSchematicSettings]
Misc::init_window $setting ${Schematic.1}
::Misc::exec_method -window ${Schematic.1} -method captionCmd
gui_add_icon_to_taskbar -window ${Schematic.1}
gui_show_window -window ${Schematic.1} -show_state maximized
gui_update_layout -id ${Schematic.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state normal -rect {{3 55} {1220 634}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 390} {child_wave_right 822} {child_wave_colname 231} {child_wave_colvalue 155} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}
gui_update_statusbar_target_frame ${TopLevel.2}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {tb.vpd}] } {
	gui_open_db -design V1 -file tb.vpd -nosource
}
gui_set_precision 10ps
gui_set_time_units 10ps
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups


set _session_group_181 Fetch
gui_sg_create "$_session_group_181"
set Fetch "$_session_group_181"

gui_sg_addsignal -group "$_session_group_181" { testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.rst_n testbench.u_system.u_cpu.r_EIP testbench.u_system.u_cpu.w_ld_de testbench.u_system.u_cpu.w_V_de_next testbench.u_system.u_cpu.r_de_ic_data_shifted testbench.u_system.u_cpu.r_de_EIP_curr testbench.u_system.u_cpu.r_de_CS_curr }

set _session_group_182 Decode
gui_sg_create "$_session_group_182"
set Decode "$_session_group_182"

gui_sg_addsignal -group "$_session_group_182" { testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.r_V_de testbench.u_system.u_cpu.u_decode.de_eip_len testbench.u_system.u_cpu.w_de_EIP_next testbench.u_system.u_cpu.w_ld_ag testbench.u_system.u_cpu.w_V_ag_next }

set _session_group_183 AG
gui_sg_create "$_session_group_183"
set AG "$_session_group_183"

gui_sg_addsignal -group "$_session_group_183" { testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.r_V_ag testbench.u_system.u_cpu.w_ld_ro testbench.u_system.u_cpu.w_V_ro_next testbench.u_system.u_cpu.r_ro_addr1 testbench.u_system.u_cpu.r_ro_addr2 testbench.u_system.u_cpu.r_ro_seg1_limit testbench.u_system.u_cpu.r_ro_seg2_limit }

set _session_group_184 R
gui_sg_create "$_session_group_184"
set R "$_session_group_184"

gui_sg_addsignal -group "$_session_group_184" { testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.r_V_ro testbench.u_system.u_cpu.w_ld_ex testbench.u_system.u_cpu.w_V_ex_next testbench.u_system.u_cpu.r_ex_sr2 testbench.u_system.u_cpu.r_ex_sr1 testbench.u_system.u_cpu.r_ex_mm_sr2 testbench.u_system.u_cpu.r_ex_mm_sr1 testbench.u_system.u_cpu.r_ex_mem_out_latched testbench.u_system.u_cpu.r_ex_mem_out }

set _session_group_185 EX
gui_sg_create "$_session_group_185"
set EX "$_session_group_185"

gui_sg_addsignal -group "$_session_group_185" { testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.r_V_ex testbench.u_system.u_cpu.r_wb_cmps_flags testbench.u_system.u_cpu.r_wb_alu_res3 testbench.u_system.u_cpu.r_wb_alu_res2 testbench.u_system.u_cpu.r_wb_alu_res1 testbench.u_system.u_cpu.r_wb_alu1_flags testbench.u_system.u_cpu.w_ld_wb testbench.u_system.u_cpu.w_V_wb_next }

set _session_group_186 Group6
gui_sg_create "$_session_group_186"
set Group6 "$_session_group_186"

gui_sg_addsignal -group "$_session_group_186" { testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.r_V_wb testbench.u_system.u_cpu.w_wb_wr_seg_data testbench.u_system.u_cpu.w_wb_wr_reg_data3 testbench.u_system.u_cpu.w_wb_wr_reg_data2 testbench.u_system.u_cpu.w_wb_wr_reg_data1 testbench.u_system.u_cpu.w_wb_mem_wr_data testbench.u_system.u_cpu.w_wb_flags6 testbench.u_system.u_cpu.w_v_wb_ld_seg testbench.u_system.u_cpu.w_v_wb_ld_reg3_strb testbench.u_system.u_cpu.w_v_wb_ld_reg2_strb testbench.u_system.u_cpu.w_v_wb_ld_reg1_strb testbench.u_system.u_cpu.w_v_wb_ld_mm testbench.u_system.u_cpu.w_v_wb_ld_mem }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 25208



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} testbench}
catch {gui_list_expand -id ${Hier.1} testbench.u_system}
catch {gui_list_select -id ${Hier.1} {testbench.u_system.u_cpu}}
gui_view_scroll -id ${Hier.1} -vertical -set 740
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {w_v_*}
gui_list_show_data -id ${Data.1} {testbench.u_system.u_cpu}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {testbench.u_system.u_cpu.w_v_wb_ld_seg }}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 740
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active testbench.u_system.u_cpu /home/ecelrc/students/mgontala/uarch/uarch_project/rtl/trunk/cpu/cpu.v
gui_view_scroll -id ${Source.1} -vertical -set 0
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_create -id ${Wave.1} C2 17408
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 110000
gui_list_add_group -id ${Wave.1} -after {New Group} {Fetch}
gui_list_add_group -id ${Wave.1} -after {New Group} {Decode}
gui_list_add_group -id ${Wave.1} -after {New Group} {AG}
gui_list_add_group -id ${Wave.1} -after {New Group} {R}
gui_list_add_group -id ${Wave.1} -after {New Group} {EX}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group6}
gui_list_select -id ${Wave.1} {testbench.u_system.u_cpu.r_V_wb }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group Group6  -position below

gui_marker_move -id ${Wave.1} {C1} 25208
gui_view_scroll -id ${Wave.1} -vertical -set 338
gui_show_grid -id ${Wave.1} -enable false

# DriverLoad 'DriverLoad.1'
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.w_ic_hit -time 11775 -starttime 11775
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_i_cache.ren -time 11735 -starttime 11775
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.w_de_br_stall -time 11610 -starttime 11610
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_de_dep_v_ld_logic.eip_change -time 11610 -starttime 11610
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_decode.w_mux_sel[2:0]} -time 258 -starttime 11673
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.r_de_EIP_curr[31:0]} -time 8 -starttime 12085
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.EAX[31:0]} -time 8 -starttime 10785
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.r_V_ex -time 13808 -starttime 13808
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.w_V_ex_next -time 12608 -starttime 13808
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_ro_dep_v_ld_logic.dep_stall -time 12608 -starttime 12608
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_ro_dep_v_ld_logic.v_wb_ld_reg3 -time 0 -starttime 12608
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_ro_dep_v_ld_logic.v_wb_ld_reg3 -time 0 -starttime 2671
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.w_v_wb_ld_reg3 -time 0 -starttime 2671
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_ro_dep_v_ld_logic.v_ex_ld_reg1 -time 13808 -starttime 13808
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_ro_dep_v_ld_logic.dep_stall -time 13808 -starttime 13808
gui_get_drivers -session -id ${DriverLoad.1} -signal testbench.u_system.u_cpu.u_ro_dep_v_ld_logic.mem_rd_busy -time 0 -starttime 13123
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.r_ag_dreg1[2:0]} -time 11408 -starttime 11408
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.EAX[31:0]} -time 8 -starttime 6667
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_regfile.EAX[31:0]} -time 8 -starttime 6667
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_decode.de_eip_len[3:0]} -time 403 -starttime 10250
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_decode.de_eip_len[3:0]} -time 403 -starttime 2329
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_decode.modrom_size[2:0]} -time 240 -starttime 2329
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_decode.op_rom_gen[1].rom0.mem[31:0][63:0]} -time 0 -starttime 10290
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.w_wb_wr_reg_data3[31:0]} -time 13808 -starttime 13808
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_regfile.EAX[31:0]} -time 8 -starttime 15048
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_regfile.ld_reg_0[7:0][1:0]} -time 15113 -starttime 16200
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_decode.de_dreg1[2:0]} -time 14348 -starttime 15008
gui_get_drivers -session -id ${DriverLoad.1} -signal {testbench.u_system.u_cpu.u_decode.reg_vals.w_in3[2:0]} -time 14348 -starttime 15008

# View 'Schematic.1'
gui_use_schematics

# Create path schematic window 'Schematic.1'
gui_path_show -window ${Schematic.1} -objects {testbench.u_system.u_cpu.u_reg testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.u_EIP_reg.clk testbench.u_system.u_cpu.u_V_ag.clk testbench.u_system.u_cpu.u_V_de.clk testbench.u_system.u_cpu.u_V_ex.clk testbench.u_system.u_cpu.u_V_ro.clk testbench.u_system.u_cpu.u_V_wb.clk testbench.u_system.u_cpu.u_dcache.clk testbench.u_system.u_cpu.u_de_CS_curr.clk testbench.u_system.u_cpu.u_de_EIP_curr.clk testbench.u_system.u_cpu.u_de_dep_v_ld_logic.clk testbench.u_system.u_cpu.u_de_ic_data_shifted.clk testbench.u_system.u_cpu.u_fe_fsm.clk testbench.u_system.u_cpu.u_i_cache.clk testbench.u_system.u_cpu.u_icache_lower_data.clk testbench.u_system.u_cpu.u_icache_upper_data.clk testbench.u_system.u_cpu.u_int_exp.clk testbench.u_system.u_cpu.u_mmu.clk testbench.u_system.u_cpu.u_mmx_regfile.clk testbench.u_system.u_cpu.u_r_0F.clk testbench.u_system.u_cpu.u_r_AF.clk testbench.u_system.u_cpu.u_r_CF.clk testbench.u_system.u_cpu.u_r_DF.clk testbench.u_system.u_cpu.u_r_PF.clk testbench.u_system.u_cpu.u_r_SF.clk testbench.u_system.u_cpu.u_r_ZF.clk testbench.u_system.u_cpu.u_r_ag_AF_needed.clk testbench.u_system.u_cpu.u_r_ag_CF_expected.clk testbench.u_system.u_cpu.u_r_ag_CF_needed.clk testbench.u_system.u_cpu.u_r_ag_CS_curr.clk testbench.u_system.u_cpu.u_r_ag_DF_needed.clk testbench.u_system.u_cpu.u_r_ag_EIP_EFLAGS_sel.clk testbench.u_system.u_cpu.u_r_ag_EIP_curr.clk testbench.u_system.u_cpu.u_r_ag_EIP_next.clk testbench.u_system.u_cpu.u_r_ag_SIB_pr.clk testbench.u_system.u_cpu.u_r_ag_ZF_expected.clk testbench.u_system.u_cpu.u_r_ag_alu1_op.clk testbench.u_system.u_cpu.u_r_ag_alu1_op_size.clk testbench.u_system.u_cpu.u_r_ag_alu2_op.clk testbench.u_system.u_cpu.u_r_ag_alu3_op.clk testbench.u_system.u_cpu.u_r_ag_base_sel.clk testbench.u_system.u_cpu.u_r_ag_cmps_op.clk testbench.u_system.u_cpu.u_r_ag_cond_wr_CF.clk testbench.u_system.u_cpu.u_r_ag_cond_wr_ZF.clk testbench.u_system.u_cpu.u_r_ag_cxchg_op.clk testbench.u_system.u_cpu.u_r_ag_df_val.clk testbench.u_system.u_cpu.u_r_ag_disp32.clk testbench.u_system.u_cpu.u_r_ag_disp_sel.clk testbench.u_system.u_cpu.u_r_ag_dmm.clk testbench.u_system.u_cpu.u_r_ag_dreg1.clk testbench.u_system.u_cpu.u_r_ag_dreg2.clk testbench.u_system.u_cpu.u_r_ag_dreg3.clk testbench.u_system.u_cpu.u_r_ag_dseg.clk testbench.u_system.u_cpu.u_r_ag_eax_needed.clk testbench.u_system.u_cpu.u_r_ag_ecx_needed.clk testbench.u_system.u_cpu.u_r_ag_eip_change.clk testbench.u_system.u_cpu.u_r_ag_esp_needed.clk testbench.u_system.u_cpu.u_r_ag_imm_rel_ptr32.clk testbench.u_system.u_cpu.u_r_ag_imm_sel.clk testbench.u_system.u_cpu.u_r_ag_in1.clk testbench.u_system.u_cpu.u_r_ag_in1_needed.clk testbench.u_system.u_cpu.u_r_ag_in2.clk testbench.u_system.u_cpu.u_r_ag_in2_needed.clk testbench.u_system.u_cpu.u_r_ag_in3.clk testbench.u_system.u_cpu.u_r_ag_in3_needed.clk testbench.u_system.u_cpu.u_r_ag_in4.clk testbench.u_system.u_cpu.u_r_ag_in4_needed.clk testbench.u_system.u_cpu.u_r_ag_ld_flag_AF.clk testbench.u_system.u_cpu.u_r_ag_ld_flag_CF.clk testbench.u_system.u_cpu.u_r_ag_ld_flag_DF.clk testbench.u_system.u_cpu.u_r_ag_ld_flag_OF.clk testbench.u_system.u_cpu.u_r_ag_ld_flag_PF.clk testbench.u_system.u_cpu.u_r_ag_ld_flag_SF.clk testbench.u_system.u_cpu.u_r_ag_ld_flag_ZF.clk testbench.u_system.u_cpu.u_r_ag_ld_mem.clk testbench.u_system.u_cpu.u_r_ag_ld_mm.clk testbench.u_system.u_cpu.u_r_ag_ld_reg1.clk testbench.u_system.u_cpu.u_r_ag_ld_reg1_strb.clk testbench.u_system.u_cpu.u_r_ag_ld_reg2.clk testbench.u_system.u_cpu.u_r_ag_ld_reg2_strb.clk testbench.u_system.u_cpu.u_r_ag_ld_reg3.clk testbench.u_system.u_cpu.u_r_ag_ld_reg3_strb.clk testbench.u_system.u_cpu.u_r_ag_ld_seg.clk testbench.u_system.u_cpu.u_r_ag_mem_rd_addr_sel.clk testbench.u_system.u_cpu.u_r_ag_mem_rd_size.clk testbench.u_system.u_cpu.u_r_ag_mem_read.clk testbench.u_system.u_cpu.u_r_ag_mem_wr_size.clk testbench.u_system.u_cpu.u_r_ag_mm1.clk testbench.u_system.u_cpu.u_r_ag_mm1_needed.clk testbench.u_system.u_cpu.u_r_ag_mm2.clk testbench.u_system.u_cpu.u_r_ag_mm2_needed.clk testbench.u_system.u_cpu.u_r_ag_mm_sr1_sel_H.clk testbench.u_system.u_cpu.u_r_ag_mm_sr1_sel_L.clk testbench.u_system.u_cpu.u_r_ag_mm_sr2_sel.clk testbench.u_system.u_cpu.u_r_ag_pr_size_over.clk testbench.u_system.u_cpu.u_r_ag_ptr_CS.clk testbench.u_system.u_cpu.u_r_ag_reg8_sr1_HL_sel.clk testbench.u_system.u_cpu.u_r_ag_reg8_sr2_HL_sel.clk testbench.u_system.u_cpu.u_r_ag_scale.clk testbench.u_system.u_cpu.u_r_ag_seg1.clk testbench.u_system.u_cpu.u_r_ag_seg1_needed.clk testbench.u_system.u_cpu.u_r_ag_seg2.clk testbench.u_system.u_cpu.u_r_ag_seg2_needed.clk testbench.u_system.u_cpu.u_r_ag_seg3.clk testbench.u_system.u_cpu.u_r_ag_seg3_needed.clk testbench.u_system.u_cpu.u_r_ag_sr1_sel.clk testbench.u_system.u_cpu.u_r_ag_sr2_sel.clk testbench.u_system.u_cpu.u_r_ag_stack_off_sel.clk testbench.u_system.u_cpu.u_r_ag_wr_eip_alu_res_sel.clk testbench.u_system.u_cpu.u_r_ag_wr_mem_addr_sel.clk testbench.u_system.u_cpu.u_r_ag_wr_mem_data_sel.clk testbench.u_system.u_cpu.u_r_ag_wr_reg1_data_sel.clk testbench.u_system.u_cpu.u_r_ag_wr_reg2_data_sel.clk testbench.u_system.u_cpu.u_r_ag_wr_seg_data_sel.clk testbench.u_system.u_cpu.u_r_ex_AF_needed.clk testbench.u_system.u_cpu.u_r_ex_CF_expected.clk testbench.u_system.u_cpu.u_r_ex_CF_needed.clk testbench.u_system.u_cpu.u_r_ex_DF_needed.clk testbench.u_system.u_cpu.u_r_ex_EAX.clk testbench.u_system.u_cpu.u_r_ex_ECX.clk testbench.u_system.u_cpu.u_r_ex_EIP_next.clk testbench.u_system.u_cpu.u_r_ex_ESP.clk testbench.u_system.u_cpu.u_r_ex_ISR.clk testbench.u_system.u_cpu.u_r_ex_ZF_expected.clk testbench.u_system.u_cpu.u_r_ex_alu1_op.clk testbench.u_system.u_cpu.u_r_ex_alu1_op_size.clk testbench.u_system.u_cpu.u_r_ex_alu2_op.clk testbench.u_system.u_cpu.u_r_ex_alu3_op.clk testbench.u_system.u_cpu.u_r_ex_cmps_op.clk testbench.u_system.u_cpu.u_r_ex_cond_wr_CF.clk testbench.u_system.u_cpu.u_r_ex_cond_wr_ZF.clk testbench.u_system.u_cpu.u_r_ex_cxchg_op.clk testbench.u_system.u_cpu.u_r_ex_df_val.clk testbench.u_system.u_cpu.u_r_ex_dmm.clk testbench.u_system.u_cpu.u_r_ex_dreg1.clk testbench.u_system.u_cpu.u_r_ex_dreg2.clk testbench.u_system.u_cpu.u_r_ex_dreg3.clk testbench.u_system.u_cpu.u_r_ex_dseg.clk testbench.u_system.u_cpu.u_r_ex_eip_change.clk testbench.u_system.u_cpu.u_r_ex_ld_flag_AF.clk testbench.u_system.u_cpu.u_r_ex_ld_flag_CF.clk testbench.u_system.u_cpu.u_r_ex_ld_flag_DF.clk testbench.u_system.u_cpu.u_r_ex_ld_flag_OF.clk testbench.u_system.u_cpu.u_r_ex_ld_flag_PF.clk testbench.u_system.u_cpu.u_r_ex_ld_flag_SF.clk testbench.u_system.u_cpu.u_r_ex_ld_flag_ZF.clk testbench.u_system.u_cpu.u_r_ex_ld_mem.clk testbench.u_system.u_cpu.u_r_ex_ld_mm.clk testbench.u_system.u_cpu.u_r_ex_ld_reg1.clk testbench.u_system.u_cpu.u_r_ex_ld_reg1_strb.clk testbench.u_system.u_cpu.u_r_ex_ld_reg2.clk testbench.u_system.u_cpu.u_r_ex_ld_reg2_strb.clk testbench.u_system.u_cpu.u_r_ex_ld_reg3.clk testbench.u_system.u_cpu.u_r_ex_ld_reg3_strb.clk testbench.u_system.u_cpu.u_r_ex_ld_seg.clk testbench.u_system.u_cpu.u_r_ex_mem_out.clk testbench.u_system.u_cpu.u_r_ex_mem_out_latched.clk testbench.u_system.u_cpu.u_r_ex_mem_rd_size.clk testbench.u_system.u_cpu.u_r_ex_mem_wr_addr.clk testbench.u_system.u_cpu.u_r_ex_mem_wr_size.clk testbench.u_system.u_cpu.u_r_ex_mm_sr1.clk testbench.u_system.u_cpu.u_r_ex_mm_sr2.clk testbench.u_system.u_cpu.u_r_ex_pr_size_over.clk testbench.u_system.u_cpu.u_r_ex_ptr_CS.clk testbench.u_system.u_cpu.u_r_ex_reg8_sr1_HL_sel.clk testbench.u_system.u_cpu.u_r_ex_reg8_sr2_HL_sel.clk testbench.u_system.u_cpu.u_r_ex_sr1.clk testbench.u_system.u_cpu.u_r_ex_sr2.clk testbench.u_system.u_cpu.u_r_ex_wr_eip_alu_res_sel.clk testbench.u_system.u_cpu.u_r_ex_wr_mem_data_sel.clk testbench.u_system.u_cpu.u_r_ex_wr_reg1_data_sel.clk testbench.u_system.u_cpu.u_r_ex_wr_reg2_data_sel.clk testbench.u_system.u_cpu.u_r_ex_wr_seg_data_sel.clk testbench.u_system.u_cpu.u_r_flag13589.clk testbench.u_system.u_cpu.u_r_flag_others.clk testbench.u_system.u_cpu.u_r_ro_AF_needed.clk testbench.u_system.u_cpu.u_r_ro_CF_expected.clk testbench.u_system.u_cpu.u_r_ro_CF_needed.clk testbench.u_system.u_cpu.u_r_ro_CS_curr.clk testbench.u_system.u_cpu.u_r_ro_DF_needed.clk testbench.u_system.u_cpu.u_r_ro_EIP_EFLAGS_sel.clk testbench.u_system.u_cpu.u_r_ro_EIP_curr.clk testbench.u_system.u_cpu.u_r_ro_EIP_next.clk testbench.u_system.u_cpu.u_r_ro_ESP.clk testbench.u_system.u_cpu.u_r_ro_ISR.clk testbench.u_system.u_cpu.u_r_ro_ZF_expected.clk testbench.u_system.u_cpu.u_r_ro_addr1.clk testbench.u_system.u_cpu.u_r_ro_addr1_offset.clk testbench.u_system.u_cpu.u_r_ro_addr2.clk testbench.u_system.u_cpu.u_r_ro_addr2_offset.clk testbench.u_system.u_cpu.u_r_ro_alu1_op.clk testbench.u_system.u_cpu.u_r_ro_alu1_op_size.clk testbench.u_system.u_cpu.u_r_ro_alu2_op.clk testbench.u_system.u_cpu.u_r_ro_alu3_op.clk testbench.u_system.u_cpu.u_r_ro_cmps_op.clk testbench.u_system.u_cpu.u_r_ro_cond_wr_CF.clk testbench.u_system.u_cpu.u_r_ro_cond_wr_ZF.clk testbench.u_system.u_cpu.u_r_ro_cxchg_op.clk testbench.u_system.u_cpu.u_r_ro_df_val.clk testbench.u_system.u_cpu.u_r_ro_dmm.clk testbench.u_system.u_cpu.u_r_ro_dreg1.clk testbench.u_system.u_cpu.u_r_ro_dreg2.clk testbench.u_system.u_cpu.u_r_ro_dreg3.clk testbench.u_system.u_cpu.u_r_ro_dseg.clk testbench.u_system.u_cpu.u_r_ro_eax_needed.clk testbench.u_system.u_cpu.u_r_ro_ecx_needed.clk testbench.u_system.u_cpu.u_r_ro_eip_change.clk testbench.u_system.u_cpu.u_r_ro_imm_rel_ptr32.clk testbench.u_system.u_cpu.u_r_ro_imm_sel.clk testbench.u_system.u_cpu.u_r_ro_in3.clk testbench.u_system.u_cpu.u_r_ro_in3_needed.clk testbench.u_system.u_cpu.u_r_ro_in4.clk testbench.u_system.u_cpu.u_r_ro_in4_needed.clk testbench.u_system.u_cpu.u_r_ro_ld_flag_AF.clk testbench.u_system.u_cpu.u_r_ro_ld_flag_CF.clk testbench.u_system.u_cpu.u_r_ro_ld_flag_DF.clk testbench.u_system.u_cpu.u_r_ro_ld_flag_OF.clk testbench.u_system.u_cpu.u_r_ro_ld_flag_PF.clk testbench.u_system.u_cpu.u_r_ro_ld_flag_SF.clk testbench.u_system.u_cpu.u_r_ro_ld_flag_ZF.clk testbench.u_system.u_cpu.u_r_ro_ld_mem.clk testbench.u_system.u_cpu.u_r_ro_ld_mm.clk testbench.u_system.u_cpu.u_r_ro_ld_reg1.clk testbench.u_system.u_cpu.u_r_ro_ld_reg1_strb.clk testbench.u_system.u_cpu.u_r_ro_ld_reg2.clk testbench.u_system.u_cpu.u_r_ro_ld_reg2_strb.clk testbench.u_system.u_cpu.u_r_ro_ld_reg3.clk testbench.u_system.u_cpu.u_r_ro_ld_reg3_strb.clk testbench.u_system.u_cpu.u_r_ro_ld_seg.clk testbench.u_system.u_cpu.u_r_ro_mem_rd_addr_sel.clk testbench.u_system.u_cpu.u_r_ro_mem_rd_size.clk testbench.u_system.u_cpu.u_r_ro_mem_read.clk testbench.u_system.u_cpu.u_r_ro_mem_wr_size.clk testbench.u_system.u_cpu.u_r_ro_mm1.clk testbench.u_system.u_cpu.u_r_ro_mm1_needed.clk testbench.u_system.u_cpu.u_r_ro_mm2.clk testbench.u_system.u_cpu.u_r_ro_mm2_needed.clk testbench.u_system.u_cpu.u_r_ro_mm_sr1_sel_H.clk testbench.u_system.u_cpu.u_r_ro_mm_sr1_sel_L.clk testbench.u_system.u_cpu.u_r_ro_mm_sr2_sel.clk testbench.u_system.u_cpu.u_r_ro_pr_size_over.clk testbench.u_system.u_cpu.u_r_ro_ptr_CS.clk testbench.u_system.u_cpu.u_r_ro_reg8_sr1_HL_sel.clk testbench.u_system.u_cpu.u_r_ro_reg8_sr2_HL_sel.clk testbench.u_system.u_cpu.u_r_ro_seg1_limit.clk testbench.u_system.u_cpu.u_r_ro_seg2_limit.clk testbench.u_system.u_cpu.u_r_ro_seg3.clk testbench.u_system.u_cpu.u_r_ro_seg3_needed.clk testbench.u_system.u_cpu.u_r_ro_sr1_sel.clk testbench.u_system.u_cpu.u_r_ro_sr2_sel.clk testbench.u_system.u_cpu.u_r_ro_wr_eip_alu_res_sel.clk testbench.u_system.u_cpu.u_r_ro_wr_mem_addr_sel.clk testbench.u_system.u_cpu.u_r_ro_wr_mem_data_sel.clk testbench.u_system.u_cpu.u_r_ro_wr_reg1_data_sel.clk testbench.u_system.u_cpu.u_r_ro_wr_reg2_data_sel.clk testbench.u_system.u_cpu.u_r_ro_wr_seg_data_sel.clk testbench.u_system.u_cpu.u_r_wb_CF_expected.clk testbench.u_system.u_cpu.u_r_wb_EIP_next.clk testbench.u_system.u_cpu.u_r_wb_ZF_expected.clk testbench.u_system.u_cpu.u_r_wb_alu1_flags.clk testbench.u_system.u_cpu.u_r_wb_alu_res1.clk testbench.u_system.u_cpu.u_r_wb_alu_res2.clk testbench.u_system.u_cpu.u_r_wb_alu_res3.clk testbench.u_system.u_cpu.u_r_wb_cmps_flags.clk testbench.u_system.u_cpu.u_r_wb_cmps_op.clk testbench.u_system.u_cpu.u_r_wb_cond_wr_CF.clk testbench.u_system.u_cpu.u_r_wb_cond_wr_ZF.clk testbench.u_system.u_cpu.u_r_wb_cxchg_op.clk testbench.u_system.u_cpu.u_r_wb_df_val_ex.clk testbench.u_system.u_cpu.u_r_wb_dmm.clk testbench.u_system.u_cpu.u_r_wb_dreg1.clk testbench.u_system.u_cpu.u_r_wb_dreg2.clk testbench.u_system.u_cpu.u_r_wb_dreg3.clk testbench.u_system.u_cpu.u_r_wb_dseg.clk testbench.u_system.u_cpu.u_r_wb_eip_change.clk testbench.u_system.u_cpu.u_r_wb_ld_flag_AF.clk testbench.u_system.u_cpu.u_r_wb_ld_flag_CF.clk testbench.u_system.u_cpu.u_r_wb_ld_flag_DF.clk testbench.u_system.u_cpu.u_r_wb_ld_flag_OF.clk testbench.u_system.u_cpu.u_r_wb_ld_flag_PF.clk testbench.u_system.u_cpu.u_r_wb_ld_flag_SF.clk testbench.u_system.u_cpu.u_r_wb_ld_flag_ZF.clk testbench.u_system.u_cpu.u_r_wb_ld_mem.clk testbench.u_system.u_cpu.u_r_wb_ld_mm.clk testbench.u_system.u_cpu.u_r_wb_ld_reg1.clk testbench.u_system.u_cpu.u_r_wb_ld_reg1_strb.clk testbench.u_system.u_cpu.u_r_wb_ld_reg2.clk testbench.u_system.u_cpu.u_r_wb_ld_reg2_strb.clk testbench.u_system.u_cpu.u_r_wb_ld_reg3.clk testbench.u_system.u_cpu.u_r_wb_ld_reg3_strb.clk testbench.u_system.u_cpu.u_r_wb_ld_seg.clk testbench.u_system.u_cpu.u_r_wb_mem_wr_addr.clk testbench.u_system.u_cpu.u_r_wb_mem_wr_size.clk testbench.u_system.u_cpu.u_r_wb_pr_size_over.clk testbench.u_system.u_cpu.u_r_wb_ptr_CS.clk testbench.u_system.u_cpu.u_r_wb_reg8_sr1_HL_sel.clk testbench.u_system.u_cpu.u_r_wb_reg8_sr2_HL_sel.clk testbench.u_system.u_cpu.u_r_wb_wr_eip_alu_res_sel.clk testbench.u_system.u_cpu.u_r_wb_wr_mem_data_sel.clk testbench.u_system.u_cpu.u_r_wb_wr_reg1_data_sel.clk testbench.u_system.u_cpu.u_r_wb_wr_reg2_data_sel.clk testbench.u_system.u_cpu.u_r_wb_wr_seg_data_sel.clk testbench.u_system.u_cpu.u_regfile.clk testbench.u_system.u_cpu.u_seg_regfile.clk testbench.u_system.u_cpu.u_w_ro_mem_out_latched.clk testbench.u_system.u_cpu.u_wr_fifo.clk testbench.u_system.u_cpu.rst_n testbench.u_system.u_cpu.u_EIP_reg.rst_n testbench.u_system.u_cpu.u_V_ag.rst_n testbench.u_system.u_cpu.u_V_de.rst_n testbench.u_system.u_cpu.u_V_ex.rst_n testbench.u_system.u_cpu.u_V_ro.rst_n testbench.u_system.u_cpu.u_V_wb.rst_n testbench.u_system.u_cpu.u_dcache.rst_n testbench.u_system.u_cpu.u_de_CS_curr.rst_n testbench.u_system.u_cpu.u_de_EIP_curr.rst_n testbench.u_system.u_cpu.u_de_dep_v_ld_logic.rst_n testbench.u_system.u_cpu.u_de_ic_data_shifted.rst_n testbench.u_system.u_cpu.u_fe_fsm.rst_n testbench.u_system.u_cpu.u_i_cache.rst_n testbench.u_system.u_cpu.u_icache_lower_data.rst_n testbench.u_system.u_cpu.u_icache_upper_data.rst_n testbench.u_system.u_cpu.u_int_exp.rst_n testbench.u_system.u_cpu.u_mmu.rst_n testbench.u_system.u_cpu.u_mmx_regfile.rst_n testbench.u_system.u_cpu.u_r_0F.rst_n testbench.u_system.u_cpu.u_r_AF.rst_n testbench.u_system.u_cpu.u_r_CF.rst_n testbench.u_system.u_cpu.u_r_DF.rst_n testbench.u_system.u_cpu.u_r_PF.rst_n testbench.u_system.u_cpu.u_r_SF.rst_n testbench.u_system.u_cpu.u_r_ZF.rst_n testbench.u_system.u_cpu.u_r_ag_AF_needed.rst_n testbench.u_system.u_cpu.u_r_ag_CF_expected.rst_n testbench.u_system.u_cpu.u_r_ag_CF_needed.rst_n testbench.u_system.u_cpu.u_r_ag_CS_curr.rst_n testbench.u_system.u_cpu.u_r_ag_DF_needed.rst_n testbench.u_system.u_cpu.u_r_ag_EIP_EFLAGS_sel.rst_n testbench.u_system.u_cpu.u_r_ag_EIP_curr.rst_n testbench.u_system.u_cpu.u_r_ag_EIP_next.rst_n testbench.u_system.u_cpu.u_r_ag_SIB_pr.rst_n testbench.u_system.u_cpu.u_r_ag_ZF_expected.rst_n testbench.u_system.u_cpu.u_r_ag_alu1_op.rst_n testbench.u_system.u_cpu.u_r_ag_alu1_op_size.rst_n testbench.u_system.u_cpu.u_r_ag_alu2_op.rst_n testbench.u_system.u_cpu.u_r_ag_alu3_op.rst_n testbench.u_system.u_cpu.u_r_ag_base_sel.rst_n testbench.u_system.u_cpu.u_r_ag_cmps_op.rst_n testbench.u_system.u_cpu.u_r_ag_cond_wr_CF.rst_n testbench.u_system.u_cpu.u_r_ag_cond_wr_ZF.rst_n testbench.u_system.u_cpu.u_r_ag_cxchg_op.rst_n testbench.u_system.u_cpu.u_r_ag_df_val.rst_n testbench.u_system.u_cpu.u_r_ag_disp32.rst_n testbench.u_system.u_cpu.u_r_ag_disp_sel.rst_n testbench.u_system.u_cpu.u_r_ag_dmm.rst_n testbench.u_system.u_cpu.u_r_ag_dreg1.rst_n testbench.u_system.u_cpu.u_r_ag_dreg2.rst_n testbench.u_system.u_cpu.u_r_ag_dreg3.rst_n testbench.u_system.u_cpu.u_r_ag_dseg.rst_n testbench.u_system.u_cpu.u_r_ag_eax_needed.rst_n testbench.u_system.u_cpu.u_r_ag_ecx_needed.rst_n testbench.u_system.u_cpu.u_r_ag_eip_change.rst_n testbench.u_system.u_cpu.u_r_ag_esp_needed.rst_n testbench.u_system.u_cpu.u_r_ag_imm_rel_ptr32.rst_n testbench.u_system.u_cpu.u_r_ag_imm_sel.rst_n testbench.u_system.u_cpu.u_r_ag_in1.rst_n testbench.u_system.u_cpu.u_r_ag_in1_needed.rst_n testbench.u_system.u_cpu.u_r_ag_in2.rst_n testbench.u_system.u_cpu.u_r_ag_in2_needed.rst_n testbench.u_system.u_cpu.u_r_ag_in3.rst_n testbench.u_system.u_cpu.u_r_ag_in3_needed.rst_n testbench.u_system.u_cpu.u_r_ag_in4.rst_n testbench.u_system.u_cpu.u_r_ag_in4_needed.rst_n testbench.u_system.u_cpu.u_r_ag_ld_flag_AF.rst_n testbench.u_system.u_cpu.u_r_ag_ld_flag_CF.rst_n testbench.u_system.u_cpu.u_r_ag_ld_flag_DF.rst_n testbench.u_system.u_cpu.u_r_ag_ld_flag_OF.rst_n testbench.u_system.u_cpu.u_r_ag_ld_flag_PF.rst_n testbench.u_system.u_cpu.u_r_ag_ld_flag_SF.rst_n testbench.u_system.u_cpu.u_r_ag_ld_flag_ZF.rst_n testbench.u_system.u_cpu.u_r_ag_ld_mem.rst_n testbench.u_system.u_cpu.u_r_ag_ld_mm.rst_n testbench.u_system.u_cpu.u_r_ag_ld_reg1.rst_n testbench.u_system.u_cpu.u_r_ag_ld_reg1_strb.rst_n testbench.u_system.u_cpu.u_r_ag_ld_reg2.rst_n testbench.u_system.u_cpu.u_r_ag_ld_reg2_strb.rst_n testbench.u_system.u_cpu.u_r_ag_ld_reg3.rst_n testbench.u_system.u_cpu.u_r_ag_ld_reg3_strb.rst_n testbench.u_system.u_cpu.u_r_ag_ld_seg.rst_n testbench.u_system.u_cpu.u_r_ag_mem_rd_addr_sel.rst_n testbench.u_system.u_cpu.u_r_ag_mem_rd_size.rst_n testbench.u_system.u_cpu.u_r_ag_mem_read.rst_n testbench.u_system.u_cpu.u_r_ag_mem_wr_size.rst_n testbench.u_system.u_cpu.u_r_ag_mm1.rst_n testbench.u_system.u_cpu.u_r_ag_mm1_needed.rst_n testbench.u_system.u_cpu.u_r_ag_mm2.rst_n testbench.u_system.u_cpu.u_r_ag_mm2_needed.rst_n testbench.u_system.u_cpu.u_r_ag_mm_sr1_sel_H.rst_n testbench.u_system.u_cpu.u_r_ag_mm_sr1_sel_L.rst_n testbench.u_system.u_cpu.u_r_ag_mm_sr2_sel.rst_n testbench.u_system.u_cpu.u_r_ag_pr_size_over.rst_n testbench.u_system.u_cpu.u_r_ag_ptr_CS.rst_n testbench.u_system.u_cpu.u_r_ag_reg8_sr1_HL_sel.rst_n testbench.u_system.u_cpu.u_r_ag_reg8_sr2_HL_sel.rst_n testbench.u_system.u_cpu.u_r_ag_scale.rst_n testbench.u_system.u_cpu.u_r_ag_seg1.rst_n testbench.u_system.u_cpu.u_r_ag_seg1_needed.rst_n testbench.u_system.u_cpu.u_r_ag_seg2.rst_n testbench.u_system.u_cpu.u_r_ag_seg2_needed.rst_n testbench.u_system.u_cpu.u_r_ag_seg3.rst_n testbench.u_system.u_cpu.u_r_ag_seg3_needed.rst_n testbench.u_system.u_cpu.u_r_ag_sr1_sel.rst_n testbench.u_system.u_cpu.u_r_ag_sr2_sel.rst_n testbench.u_system.u_cpu.u_r_ag_stack_off_sel.rst_n testbench.u_system.u_cpu.u_r_ag_wr_eip_alu_res_sel.rst_n testbench.u_system.u_cpu.u_r_ag_wr_mem_addr_sel.rst_n testbench.u_system.u_cpu.u_r_ag_wr_mem_data_sel.rst_n testbench.u_system.u_cpu.u_r_ag_wr_reg1_data_sel.rst_n testbench.u_system.u_cpu.u_r_ag_wr_reg2_data_sel.rst_n testbench.u_system.u_cpu.u_r_ag_wr_seg_data_sel.rst_n testbench.u_system.u_cpu.u_r_ex_AF_needed.rst_n testbench.u_system.u_cpu.u_r_ex_CF_expected.rst_n testbench.u_system.u_cpu.u_r_ex_CF_needed.rst_n testbench.u_system.u_cpu.u_r_ex_DF_needed.rst_n testbench.u_system.u_cpu.u_r_ex_EAX.rst_n testbench.u_system.u_cpu.u_r_ex_ECX.rst_n testbench.u_system.u_cpu.u_r_ex_EIP_next.rst_n testbench.u_system.u_cpu.u_r_ex_ESP.rst_n testbench.u_system.u_cpu.u_r_ex_ISR.rst_n testbench.u_system.u_cpu.u_r_ex_ZF_expected.rst_n testbench.u_system.u_cpu.u_r_ex_alu1_op.rst_n testbench.u_system.u_cpu.u_r_ex_alu1_op_size.rst_n testbench.u_system.u_cpu.u_r_ex_alu2_op.rst_n testbench.u_system.u_cpu.u_r_ex_alu3_op.rst_n testbench.u_system.u_cpu.u_r_ex_cmps_op.rst_n testbench.u_system.u_cpu.u_r_ex_cond_wr_CF.rst_n testbench.u_system.u_cpu.u_r_ex_cond_wr_ZF.rst_n testbench.u_system.u_cpu.u_r_ex_cxchg_op.rst_n testbench.u_system.u_cpu.u_r_ex_df_val.rst_n testbench.u_system.u_cpu.u_r_ex_dmm.rst_n testbench.u_system.u_cpu.u_r_ex_dreg1.rst_n testbench.u_system.u_cpu.u_r_ex_dreg2.rst_n testbench.u_system.u_cpu.u_r_ex_dreg3.rst_n testbench.u_system.u_cpu.u_r_ex_dseg.rst_n testbench.u_system.u_cpu.u_r_ex_eip_change.rst_n testbench.u_system.u_cpu.u_r_ex_ld_flag_AF.rst_n testbench.u_system.u_cpu.u_r_ex_ld_flag_CF.rst_n testbench.u_system.u_cpu.u_r_ex_ld_flag_DF.rst_n testbench.u_system.u_cpu.u_r_ex_ld_flag_OF.rst_n testbench.u_system.u_cpu.u_r_ex_ld_flag_PF.rst_n testbench.u_system.u_cpu.u_r_ex_ld_flag_SF.rst_n testbench.u_system.u_cpu.u_r_ex_ld_flag_ZF.rst_n testbench.u_system.u_cpu.u_r_ex_ld_mem.rst_n testbench.u_system.u_cpu.u_r_ex_ld_mm.rst_n testbench.u_system.u_cpu.u_r_ex_ld_reg1.rst_n testbench.u_system.u_cpu.u_r_ex_ld_reg1_strb.rst_n testbench.u_system.u_cpu.u_r_ex_ld_reg2.rst_n testbench.u_system.u_cpu.u_r_ex_ld_reg2_strb.rst_n testbench.u_system.u_cpu.u_r_ex_ld_reg3.rst_n testbench.u_system.u_cpu.u_r_ex_ld_reg3_strb.rst_n testbench.u_system.u_cpu.u_r_ex_ld_seg.rst_n testbench.u_system.u_cpu.u_r_ex_mem_out.rst_n testbench.u_system.u_cpu.u_r_ex_mem_out_latched.rst_n testbench.u_system.u_cpu.u_r_ex_mem_rd_size.rst_n testbench.u_system.u_cpu.u_r_ex_mem_wr_addr.rst_n testbench.u_system.u_cpu.u_r_ex_mem_wr_size.rst_n testbench.u_system.u_cpu.u_r_ex_mm_sr1.rst_n testbench.u_system.u_cpu.u_r_ex_mm_sr2.rst_n testbench.u_system.u_cpu.u_r_ex_pr_size_over.rst_n testbench.u_system.u_cpu.u_r_ex_ptr_CS.rst_n testbench.u_system.u_cpu.u_r_ex_reg8_sr1_HL_sel.rst_n testbench.u_system.u_cpu.u_r_ex_reg8_sr2_HL_sel.rst_n testbench.u_system.u_cpu.u_r_ex_sr1.rst_n testbench.u_system.u_cpu.u_r_ex_sr2.rst_n testbench.u_system.u_cpu.u_r_ex_wr_eip_alu_res_sel.rst_n testbench.u_system.u_cpu.u_r_ex_wr_mem_data_sel.rst_n testbench.u_system.u_cpu.u_r_ex_wr_reg1_data_sel.rst_n testbench.u_system.u_cpu.u_r_ex_wr_reg2_data_sel.rst_n testbench.u_system.u_cpu.u_r_ex_wr_seg_data_sel.rst_n testbench.u_system.u_cpu.u_r_flag13589.rst_n testbench.u_system.u_cpu.u_r_flag_others.rst_n testbench.u_system.u_cpu.u_r_ro_AF_needed.rst_n testbench.u_system.u_cpu.u_r_ro_CF_expected.rst_n testbench.u_system.u_cpu.u_r_ro_CF_needed.rst_n testbench.u_system.u_cpu.u_r_ro_CS_curr.rst_n testbench.u_system.u_cpu.u_r_ro_DF_needed.rst_n testbench.u_system.u_cpu.u_r_ro_EIP_EFLAGS_sel.rst_n testbench.u_system.u_cpu.u_r_ro_EIP_curr.rst_n testbench.u_system.u_cpu.u_r_ro_EIP_next.rst_n testbench.u_system.u_cpu.u_r_ro_ESP.rst_n testbench.u_system.u_cpu.u_r_ro_ISR.rst_n testbench.u_system.u_cpu.u_r_ro_ZF_expected.rst_n testbench.u_system.u_cpu.u_r_ro_addr1.rst_n testbench.u_system.u_cpu.u_r_ro_addr1_offset.rst_n testbench.u_system.u_cpu.u_r_ro_addr2.rst_n testbench.u_system.u_cpu.u_r_ro_addr2_offset.rst_n testbench.u_system.u_cpu.u_r_ro_alu1_op.rst_n testbench.u_system.u_cpu.u_r_ro_alu1_op_size.rst_n testbench.u_system.u_cpu.u_r_ro_alu2_op.rst_n testbench.u_system.u_cpu.u_r_ro_alu3_op.rst_n testbench.u_system.u_cpu.u_r_ro_cmps_op.rst_n testbench.u_system.u_cpu.u_r_ro_cond_wr_CF.rst_n testbench.u_system.u_cpu.u_r_ro_cond_wr_ZF.rst_n testbench.u_system.u_cpu.u_r_ro_cxchg_op.rst_n testbench.u_system.u_cpu.u_r_ro_df_val.rst_n testbench.u_system.u_cpu.u_r_ro_dmm.rst_n testbench.u_system.u_cpu.u_r_ro_dreg1.rst_n testbench.u_system.u_cpu.u_r_ro_dreg2.rst_n testbench.u_system.u_cpu.u_r_ro_dreg3.rst_n testbench.u_system.u_cpu.u_r_ro_dseg.rst_n testbench.u_system.u_cpu.u_r_ro_eax_needed.rst_n testbench.u_system.u_cpu.u_r_ro_ecx_needed.rst_n testbench.u_system.u_cpu.u_r_ro_eip_change.rst_n testbench.u_system.u_cpu.u_r_ro_imm_rel_ptr32.rst_n testbench.u_system.u_cpu.u_r_ro_imm_sel.rst_n testbench.u_system.u_cpu.u_r_ro_in3.rst_n testbench.u_system.u_cpu.u_r_ro_in3_needed.rst_n testbench.u_system.u_cpu.u_r_ro_in4.rst_n testbench.u_system.u_cpu.u_r_ro_in4_needed.rst_n testbench.u_system.u_cpu.u_r_ro_ld_flag_AF.rst_n testbench.u_system.u_cpu.u_r_ro_ld_flag_CF.rst_n testbench.u_system.u_cpu.u_r_ro_ld_flag_DF.rst_n testbench.u_system.u_cpu.u_r_ro_ld_flag_OF.rst_n testbench.u_system.u_cpu.u_r_ro_ld_flag_PF.rst_n testbench.u_system.u_cpu.u_r_ro_ld_flag_SF.rst_n testbench.u_system.u_cpu.u_r_ro_ld_flag_ZF.rst_n testbench.u_system.u_cpu.u_r_ro_ld_mem.rst_n testbench.u_system.u_cpu.u_r_ro_ld_mm.rst_n testbench.u_system.u_cpu.u_r_ro_ld_reg1.rst_n testbench.u_system.u_cpu.u_r_ro_ld_reg1_strb.rst_n testbench.u_system.u_cpu.u_r_ro_ld_reg2.rst_n testbench.u_system.u_cpu.u_r_ro_ld_reg2_strb.rst_n testbench.u_system.u_cpu.u_r_ro_ld_reg3.rst_n testbench.u_system.u_cpu.u_r_ro_ld_reg3_strb.rst_n testbench.u_system.u_cpu.u_r_ro_ld_seg.rst_n testbench.u_system.u_cpu.u_r_ro_mem_rd_addr_sel.rst_n testbench.u_system.u_cpu.u_r_ro_mem_rd_size.rst_n testbench.u_system.u_cpu.u_r_ro_mem_read.rst_n testbench.u_system.u_cpu.u_r_ro_mem_wr_size.rst_n testbench.u_system.u_cpu.u_r_ro_mm1.rst_n testbench.u_system.u_cpu.u_r_ro_mm1_needed.rst_n testbench.u_system.u_cpu.u_r_ro_mm2.rst_n testbench.u_system.u_cpu.u_r_ro_mm2_needed.rst_n testbench.u_system.u_cpu.u_r_ro_mm_sr1_sel_H.rst_n testbench.u_system.u_cpu.u_r_ro_mm_sr1_sel_L.rst_n testbench.u_system.u_cpu.u_r_ro_mm_sr2_sel.rst_n testbench.u_system.u_cpu.u_r_ro_pr_size_over.rst_n testbench.u_system.u_cpu.u_r_ro_ptr_CS.rst_n testbench.u_system.u_cpu.u_r_ro_reg8_sr1_HL_sel.rst_n testbench.u_system.u_cpu.u_r_ro_reg8_sr2_HL_sel.rst_n testbench.u_system.u_cpu.u_r_ro_seg1_limit.rst_n testbench.u_system.u_cpu.u_r_ro_seg2_limit.rst_n testbench.u_system.u_cpu.u_r_ro_seg3.rst_n testbench.u_system.u_cpu.u_r_ro_seg3_needed.rst_n testbench.u_system.u_cpu.u_r_ro_sr1_sel.rst_n testbench.u_system.u_cpu.u_r_ro_sr2_sel.rst_n testbench.u_system.u_cpu.u_r_ro_wr_eip_alu_res_sel.rst_n testbench.u_system.u_cpu.u_r_ro_wr_mem_addr_sel.rst_n testbench.u_system.u_cpu.u_r_ro_wr_mem_data_sel.rst_n testbench.u_system.u_cpu.u_r_ro_wr_reg1_data_sel.rst_n testbench.u_system.u_cpu.u_r_ro_wr_reg2_data_sel.rst_n testbench.u_system.u_cpu.u_r_ro_wr_seg_data_sel.rst_n testbench.u_system.u_cpu.u_r_wb_CF_expected.rst_n testbench.u_system.u_cpu.u_r_wb_EIP_next.rst_n testbench.u_system.u_cpu.u_r_wb_ZF_expected.rst_n testbench.u_system.u_cpu.u_r_wb_alu1_flags.rst_n testbench.u_system.u_cpu.u_r_wb_alu_res1.rst_n testbench.u_system.u_cpu.u_r_wb_alu_res2.rst_n testbench.u_system.u_cpu.u_r_wb_alu_res3.rst_n testbench.u_system.u_cpu.u_r_wb_cmps_flags.rst_n testbench.u_system.u_cpu.u_r_wb_cmps_op.rst_n testbench.u_system.u_cpu.u_r_wb_cond_wr_CF.rst_n testbench.u_system.u_cpu.u_r_wb_cond_wr_ZF.rst_n testbench.u_system.u_cpu.u_r_wb_cxchg_op.rst_n testbench.u_system.u_cpu.u_r_wb_df_val_ex.rst_n testbench.u_system.u_cpu.u_r_wb_dmm.rst_n testbench.u_system.u_cpu.u_r_wb_dreg1.rst_n testbench.u_system.u_cpu.u_r_wb_dreg2.rst_n testbench.u_system.u_cpu.u_r_wb_dreg3.rst_n testbench.u_system.u_cpu.u_r_wb_dseg.rst_n testbench.u_system.u_cpu.u_r_wb_eip_change.rst_n testbench.u_system.u_cpu.u_r_wb_ld_flag_AF.rst_n testbench.u_system.u_cpu.u_r_wb_ld_flag_CF.rst_n testbench.u_system.u_cpu.u_r_wb_ld_flag_DF.rst_n testbench.u_system.u_cpu.u_r_wb_ld_flag_OF.rst_n testbench.u_system.u_cpu.u_r_wb_ld_flag_PF.rst_n testbench.u_system.u_cpu.u_r_wb_ld_flag_SF.rst_n testbench.u_system.u_cpu.u_r_wb_ld_flag_ZF.rst_n testbench.u_system.u_cpu.u_r_wb_ld_mem.rst_n testbench.u_system.u_cpu.u_r_wb_ld_mm.rst_n testbench.u_system.u_cpu.u_r_wb_ld_reg1.rst_n testbench.u_system.u_cpu.u_r_wb_ld_reg1_strb.rst_n testbench.u_system.u_cpu.u_r_wb_ld_reg2.rst_n testbench.u_system.u_cpu.u_r_wb_ld_reg2_strb.rst_n testbench.u_system.u_cpu.u_r_wb_ld_reg3.rst_n testbench.u_system.u_cpu.u_r_wb_ld_reg3_strb.rst_n testbench.u_system.u_cpu.u_r_wb_ld_seg.rst_n testbench.u_system.u_cpu.u_r_wb_mem_wr_addr.rst_n testbench.u_system.u_cpu.u_r_wb_mem_wr_size.rst_n testbench.u_system.u_cpu.u_r_wb_pr_size_over.rst_n testbench.u_system.u_cpu.u_r_wb_ptr_CS.rst_n testbench.u_system.u_cpu.u_r_wb_reg8_sr1_HL_sel.rst_n testbench.u_system.u_cpu.u_r_wb_reg8_sr2_HL_sel.rst_n testbench.u_system.u_cpu.u_r_wb_wr_eip_alu_res_sel.rst_n testbench.u_system.u_cpu.u_r_wb_wr_mem_data_sel.rst_n testbench.u_system.u_cpu.u_r_wb_wr_reg1_data_sel.rst_n testbench.u_system.u_cpu.u_r_wb_wr_reg2_data_sel.rst_n testbench.u_system.u_cpu.u_r_wb_wr_seg_data_sel.rst_n testbench.u_system.u_cpu.u_regfile.rst_n testbench.u_system.u_cpu.u_seg_regfile.rst_n testbench.u_system.u_cpu.u_w_ro_mem_out_latched.rst_n testbench.u_system.u_cpu.u_wr_fifo.rst_n testbench.u_system.u_cpu.clk testbench.u_system.u_cpu.rst_n}
gui_show_pin_value_annotate [gui_window_hier_name -window ${Schematic.1}]
gui_zoom -window ${Schematic.1} -rect { {-2531038 -2535645} {2547225 28379} }


# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

