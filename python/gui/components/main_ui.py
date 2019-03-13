#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import wx
import sys
import time
import serial
import string
import binascii
import threading

import errno

from utils import binary_to_dec
from utils import instruction_decode
from utils import mipsdecoder
from wx import *
from components import serial_config_dialog
from wx.lib.mixins.listctrl import ListCtrlAutoWidthMixin

SERIALRX = wx.NewEventType()
# bind to serial data receive events
EVT_SERIALRX = wx.PyEventBinder(SERIALRX, 0)


class SerialRxEvent(wx.PyCommandEvent):
    eventType = SERIALRX

    def __init__(self, windowID, data):
        wx.PyCommandEvent.__init__(self, self.eventType, windowID)
        self.data = data

    def Clone(self):
        self.__class__(self.GetId(), self.data)


class AutoWidthListCtrl(wx.ListCtrl, ListCtrlAutoWidthMixin):
    def __init__(self, parent):
        wx.ListCtrl.__init__(self, parent, -1, style=wx.LC_REPORT)
        ListCtrlAutoWidthMixin.__init__(self)


class MicompsFrame(wx.Frame):
    def __init__(self, *args, **kwds):
        wx.Frame.__init__(self, *args, **kwds)

        self.data_recived = ''
        self.registers_tuples = []
        self.step1_input_tuples = []
        self.step1_output_tuples = []
        self.step2_input_tuples = []
        self.step2_output_tuples = []
        self.step3_input_tuples = []
        self.step3_output_tuples = []
        self.step4_input_tuples = []
        self.step4_output_tuples = []
        self.step5_input_tuples = []
        self.step5_output_tuples = []
        self.instructions_list = []
        self.pipeline_tuples = []

        self.lists = []
        self.serial = serial.Serial()


        self.serial.timeout = 0
        self.thread = None
        self.alive = threading.Event()

        self.__make_bars()
        self.__make_main_section()
        self.__set_properties()
        self.__do_layout()
        self.__set_events()

        self.__on_port_settings(None)  # call setup dialog on startup, opens port
        #if not self.alive.isSet():
        #    self.Close()

    def __make_bars(self):
        self.file = wx.Menu()
        self.help = wx.Menu()

        self.itemPortSettings = self.file.Append(wx.ID_ANY, "&Configurar serial\tCtrl+Alt+S",
                                                 " Configuracion puerto serial ")
        self.file.AppendSeparator()
        self.itemRun = self.file.Append(wx.ID_ANY, "&Modo Fast\tCtrl+Shift+F5", " Ejecuta todas las instrucciones")    
        self.itemStep = self.file.Append(wx.ID_ANY, "&Modo Step by Step\tCtrl+F5", " Selecciona el modo step by step")

        self.itemClock = self.file.Append(wx.ID_ANY, "&Step\tShift+F5", " Siguiente paso del modo step by step")
        self.itemLoad = self.file.Append(wx.ID_ANY, "&Load\tF6", " Load a FPGA")
        self.itemConv = self.file.Append(wx.ID_ANY, "&Convert\tF7", " Convertir ASM to BIN")

        self.file.AppendSeparator()
        self.itemExit = self.file.Append(wx.ID_EXIT, "&Exit\tCtrl+Q", " Cierra el programa")
        self.itemHelp = self.help.Append(wx.ID_HELP_CONTENTS, "&Ayuda\tF1", " Muestra el ayuda")
        self.itemAbout = self.help.Append(wx.ID_ABOUT, "&About\tCtrl+A", " Muestra informacion sobre MIcomPS")

        self.main_frame_menubar = wx.MenuBar()
        self.main_frame_menubar.Append(self.file, "&Archivo")
        self.main_frame_menubar.Append(self.help, "&Ayuda")
        self.SetMenuBar(self.main_frame_menubar)

        self.main_frame_toolbar = wx.ToolBar(self, wx.ID_ANY, style=wx.TB_HORIZONTAL | TB_FLAT)
        self.button_port_settings = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "CONFIGURAR SERIAL", pos=(-1, -1),
                                              size=(100, -1))
        self.button_step = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "Modo Step by Step", pos=(-1, -1), size=(-1, -1))
        self.button_clock = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "Siguiente step", pos=(-1, -1), size=(-1, -1))
        self.button_run = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "Modo Fast", pos=(-1, -1), size=(-1, -1))
        self.button_load = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "Load FPGA", pos=(-1, -1),
                                               size=(100, -1))
        self.button_convert = wx.Button(self.main_frame_toolbar, wx.ID_ANY, "Convertir ASM a BIN", pos=(-1, -1),
                                               size=(100, -1))                                       
        self.main_frame_toolbar.AddControl(self.button_port_settings)
        self.main_frame_toolbar.AddSeparator()
        self.main_frame_toolbar.AddControl(self.button_step)

        self.main_frame_toolbar.AddControl(self.button_clock)
        self.main_frame_toolbar.AddControl(self.button_run)
        self.main_frame_toolbar.AddSeparator()
        self.main_frame_toolbar.AddControl(self.button_load)
        self.main_frame_toolbar.AddControl(self.button_convert)
        self.main_frame_toolbar.Realize()
        self.SetToolBar(self.main_frame_toolbar)

        self.main_frame_statusbar = self.CreateStatusBar(1)

    def __make_main_section(self):
        self.main_notebook = wx.Notebook(self, wx.ID_ANY)

        self.panel_registers_bank = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step1 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step2 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step3 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step4 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_step5 = wx.Panel(self.main_notebook, wx.ID_ANY)
        self.panel_pipeline = wx.Panel(self.main_notebook, wx.ID_ANY)

        self.panel_left_step1 = wx.Panel(self.panel_step1, wx.ID_ANY)
        self.panel_left_step2 = wx.Panel(self.panel_step2, wx.ID_ANY)
        self.panel_left_step3 = wx.Panel(self.panel_step3, wx.ID_ANY)
        self.panel_left_step4 = wx.Panel(self.panel_step4, wx.ID_ANY)
        self.panel_left_step5 = wx.Panel(self.panel_step5, wx.ID_ANY)

        self.__make_titles()
        self.__make_lists()

    def __make_titles(self):
        self.label_title_registers_bank = wx.StaticText(self.panel_registers_bank, wx.ID_ANY,
                                                        "ESTADO DE LOS REGISTROS", style=wx.ALIGN_CENTER)
        self.label_title_left_step1 = wx.StaticText(self.panel_left_step1, wx.ID_ANY, "DATOS",
                                                    style=wx.ALIGN_CENTER)
        
        self.label_title_left_step2 = wx.StaticText(self.panel_left_step2, wx.ID_ANY, "DATOS",
                                                    style=wx.ALIGN_CENTER)
        
        self.label_title_left_step3 = wx.StaticText(self.panel_left_step3, wx.ID_ANY, "DATOS",
                                                    style=wx.ALIGN_CENTER)
        
        self.label_title_left_step4 = wx.StaticText(self.panel_left_step4, wx.ID_ANY, "DATOS",
                                                    style=wx.ALIGN_CENTER)
        
        self.label_title_left_step5 = wx.StaticText(self.panel_left_step5, wx.ID_ANY, "DATOS",
                                                    style=wx.ALIGN_CENTER)
        
        self.label_title_pipeline = wx.StaticText(self.panel_pipeline, wx.ID_ANY, "DATOS",
                                                   style=wx.ALIGN_CENTER)

    def __make_lists(self):
        self.list_registers = AutoWidthListCtrl(self.panel_registers_bank)
        self.list_registers.InsertColumn(wx.ID_ANY, 'Nro.', width=-1)
        self.list_registers.InsertColumn(wx.ID_ANY, 'Binario', width=-1)
        self.list_registers.InsertColumn(wx.ID_ANY, 'U Decimal', width=-1)
        self.list_registers.InsertColumn(wx.ID_ANY, 'Decimal', width=-1)

        self.list_inputs_step1 = AutoWidthListCtrl(self.panel_left_step1)
        self.list_inputs_step1.InsertColumn(wx.ID_ANY, 'Nombre', width=-1)
        self.list_inputs_step1.InsertColumn(wx.ID_ANY, 'Valor', width=-1)

        self.list_inputs_step2 = AutoWidthListCtrl(self.panel_left_step2)
        self.list_inputs_step2.InsertColumn(wx.ID_ANY, 'Nombre', width=-1)
        self.list_inputs_step2.InsertColumn(wx.ID_ANY, 'Valor', width=-1)

        self.list_inputs_step3 = AutoWidthListCtrl(self.panel_left_step3)
        self.list_inputs_step3.InsertColumn(wx.ID_ANY, 'Nombre', width=-1)
        self.list_inputs_step3.InsertColumn(wx.ID_ANY, 'Valor', width=-1)

        self.list_inputs_step4 = AutoWidthListCtrl(self.panel_left_step4)
        self.list_inputs_step4.InsertColumn(wx.ID_ANY, 'Nombre', width=-1)
        self.list_inputs_step4.InsertColumn(wx.ID_ANY, 'Valor', width=-1)

        self.list_inputs_step5 = AutoWidthListCtrl(self.panel_left_step5)
        self.list_inputs_step5.InsertColumn(wx.ID_ANY, 'Nombre', width=-1)
        self.list_inputs_step5.InsertColumn(wx.ID_ANY, 'Valor', width=-1)

        self.list_pipeline = AutoWidthListCtrl(self.panel_pipeline)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Nombre', width=-1)
        self.list_pipeline.InsertColumn(wx.ID_ANY, 'Valor', width=-1)
        

        self.lists = [self.list_registers, self.list_inputs_step1,
                      self.list_inputs_step2, 
                      self.list_inputs_step3, 
                      self.list_inputs_step4,
                      self.list_inputs_step5,
                      self.list_pipeline ]

    def __set_properties(self):
        self.SetTitle("MIcomPS")
        self.SetSize((700, 500))
        self.main_frame_statusbar.SetStatusWidths([-1])
        self.main_frame_statusbar.SetStatusText("Desconectado", 0)

    def __do_layout(self):
        sizer_registers_bank = wx.BoxSizer(wx.VERTICAL)
        sizer_step1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step1 = wx.BoxSizer(wx.VERTICAL)
        sizer_step2 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step2 = wx.BoxSizer(wx.VERTICAL)
        sizer_step3 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step3 = wx.BoxSizer(wx.VERTICAL)
        sizer_step4 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step4 = wx.BoxSizer(wx.VERTICAL)
        sizer_step5 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_left_step5 = wx.BoxSizer(wx.VERTICAL)
        sizer_pipeline = wx.BoxSizer(wx.VERTICAL)

        sizer_registers_bank.Add(self.label_title_registers_bank, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_registers_bank.Add(self.list_registers, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_registers_bank.SetSizer(sizer_registers_bank)

        sizer_left_step1.Add(self.label_title_left_step1, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step1.Add(self.list_inputs_step1, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step1.SetSizer(sizer_left_step1)
        sizer_step1.Add(self.panel_left_step1, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step1.SetSizer(sizer_step1)

        sizer_left_step2.Add(self.label_title_left_step2, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step2.Add(self.list_inputs_step2, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step2.SetSizer(sizer_left_step2)
        sizer_step2.Add(self.panel_left_step2, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step2.SetSizer(sizer_step2)

        sizer_left_step3.Add(self.label_title_left_step3, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step3.Add(self.list_inputs_step3, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step3.SetSizer(sizer_left_step3)
        sizer_step3.Add(self.panel_left_step3, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step3.SetSizer(sizer_step3)

        sizer_left_step4.Add(self.label_title_left_step4, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step4.Add(self.list_inputs_step4, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step4.SetSizer(sizer_left_step4)
        sizer_step4.Add(self.panel_left_step4, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step4.SetSizer(sizer_step4)

        sizer_left_step5.Add(self.label_title_left_step5, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_left_step5.Add(self.list_inputs_step5, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_left_step5.SetSizer(sizer_left_step5)
        sizer_step5.Add(self.panel_left_step5, 1, wx.ALIGN_CENTER | wx.EXPAND, 5)
        self.panel_step5.SetSizer(sizer_step5)

        sizer_pipeline.Add(self.label_title_pipeline, 0, wx.ALIGN_CENTER | wx.EXPAND, 0)
        sizer_pipeline.Add(self.list_pipeline, 1, wx.ALIGN_CENTER | wx.EXPAND, 0)
        self.panel_pipeline.SetSizer(sizer_pipeline)

        self.main_notebook.AddPage(self.panel_registers_bank, "Banco de Registros")
        self.main_notebook.AddPage(self.panel_step1, "Etapa 1 - IF")
        self.main_notebook.AddPage(self.panel_step2, "Etapa 2 - ID")
        self.main_notebook.AddPage(self.panel_step3, "Etapa 3 - EX")
        self.main_notebook.AddPage(self.panel_step4, "Etapa 4 - MEM")
        self.main_notebook.AddPage(self.panel_step5, "Etapa 5 - WB")
        self.main_notebook.AddPage(self.panel_pipeline, "Clock")

        main_sizer = wx.BoxSizer(wx.VERTICAL)
        main_sizer.Add(self.main_notebook, 1, wx.ALL | wx.CENTER | wx.EXPAND, 5)

        self.SetSizer(main_sizer)
        self.Layout()

    def __set_events(self):
        self.Bind(wx.EVT_MENU, self.__on_port_settings, self.itemPortSettings)
        self.Bind(wx.EVT_MENU, self.__on_run, self.itemRun)
        self.Bind(wx.EVT_MENU, self.__on_step, self.itemStep)
        self.Bind(wx.EVT_MENU, self.__on_clock, self.itemClock)
        self.Bind(wx.EVT_MENU, self.__on_load, self.itemLoad)
        self.Bind(wx.EVT_MENU, self.__on_convert, self.itemConv)

        self.Bind(wx.EVT_MENU, self.__on_exit, self.itemExit)
        self.Bind(wx.EVT_MENU, self.__on_help, self.itemHelp)
        self.Bind(wx.EVT_MENU, self.__on_about, self.itemAbout)
        self.Bind(wx.EVT_BUTTON, self.__on_port_settings, self.button_port_settings)
        self.Bind(wx.EVT_BUTTON, self.__on_clock, self.button_clock)
        self.Bind(wx.EVT_BUTTON, self.__on_step, self.button_step)
        self.Bind(wx.EVT_BUTTON, self.__on_run, self.button_run)
        self.Bind(wx.EVT_BUTTON, self.__on_load, self.button_load)
        self.Bind(wx.EVT_BUTTON, self.__on_convert, self.button_convert)

        self.Bind(EVT_SERIALRX, self.__on_serial_read)

    def __start_thread(self):
        """Start the receiver thread"""
        self.thread = threading.Thread(target=self.__com_port_thread)
        self.thread.setDaemon(1)
        self.alive.set()
        self.thread.start()
        self.serial.rts = True
        self.serial.dtr = True

    def __stop_thread(self):
        """Stop the receiver thread, wait until it's finished."""
        if self.thread is not None:
            self.alive.clear()  # clear alive event for thread
            self.thread.join()  # wait until thread has finished
            self.thread = None

    def __add_data_recived(self, text):
        self.data_recived += text

    def __on_serial_read(self, event):
        """Handle input from the serial port."""
        self.__add_data_recived(event.data)  # str(event.data)

    def __com_port_thread(self):
        """\
        Thread that handles the incoming traffic. Does the basic input
        transformation (newlines) and generates an SerialRxEvent
        """
        while self.alive.isSet():
            b = self.serial.read(1)  # (self.serial.inWaiting() or 1)
            if b:
                if not os.path.exists(os.path.dirname("log/byte_recived_log")):
                    try:
                        os.makedirs(os.path.dirname("log/byte_recived_log"))
                    except OSError as exc:
                        if exc.errno != errno.EEXIST:
                            raise

                log = open("log/byte_recived_log", 'a+')
                log.write(binascii.b2a_hex(b) + "\n")
                log.close()
                event = SerialRxEvent(self.GetId(), binascii.b2a_hex(b))
                self.GetEventHandler().AddPendingEvent(event)

    def __hex_to_bin(self, data_hex):
        dictionary = ["0000", "0001", "0010", "0011",
                      "0100", "0101", "0110", "0111",
                      "1000", "1001", "1010", "1011",
                      "1100", "1101", "1110", "1111"]
        res = ""
        for i in range(len(data_hex)):
            res += dictionary[string.atoi(data_hex[i], base=16)]
        return res

    """
    Lee archivo con informacion del debuger.
    """
    def simula_recepcion_datos(self):
        f = open("file1.txt","r")
        cont = f.read()
        cont = cont.replace("\n","")
        read = [cont[i:i+8] for i in range(0, 2592, 8)]
        #print read
        return read

        """
    Genera un vector de todos los bits recibidos (len = 2592)
    el primer byte es el ultimo en del vector bus_from_mips.
    """
    def merge_list(self,data):
        turn_around = []
        for i in data:
            turn_around.insert(0,i)
        #print turn_around
        return "".join(turn_around)


    def __update_fields(self, data):

        self.__parse_data(data)
        i = 0
        for lista in self.lists:
            if i < 1:
                if lista.GetItemCount() > 0:
                    lista.DeleteAllItems()

                lista_tuplas = self.registers_tuples

                for tupla in lista_tuplas:
                    index = lista.InsertItem(sys.maxint, tupla[0])
                    lista.SetItem(index, 1, tupla[1])
                    lista.SetItem(index, 2, tupla[2])
                    lista.SetItem(index, 3, tupla[3])
                    lista.SetColumnWidth(0, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(1, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(2, wx.LIST_AUTOSIZE+80)
                    lista.SetColumnWidth(3, wx.LIST_AUTOSIZE)

            elif (i > 0) and (i < 11):
                if lista.GetItemCount() > 0:
                    lista.DeleteAllItems()

                lista_tuplas = []
                if i == 1:
                    lista_tuplas = self.step1_input_tuples
                elif i == 2:
                    lista_tuplas = self.step2_input_tuples
                elif i == 3:
                    lista_tuplas = self.step3_input_tuples
                elif i == 4:
                    lista_tuplas = self.step4_input_tuples
                elif i == 5:
                    lista_tuplas = self.step5_input_tuples
                elif i == 6:
                     lista_tuplas = self.pipeline_tuples
                

                for tupla in lista_tuplas:
                    index = lista.InsertItem(sys.maxint, tupla[0])
                    lista.SetItem(index, 1, tupla[1])
                    lista.SetColumnWidth(0, wx.LIST_AUTOSIZE)
                    lista.SetColumnWidth(1, wx.LIST_AUTOSIZE)
            
            i += 1

        self.data_recived = ''

    def __parse_data(self, data):
        self.registers_tuples = []
        self.registers_tuples = [
            ("Reg 0", str(data[99:131]), binary_to_dec.strbin_to_udec(str(data[99:131])),
             binary_to_dec.strbin_to_dec(str(data[99:131]))),
            ("Reg 1", str(data[131:163]), binary_to_dec.strbin_to_udec(str(data[131:163])),
             binary_to_dec.strbin_to_dec(str(data[131:163]))),
            ("Reg 2", str(data[163:195]), binary_to_dec.strbin_to_udec(str(data[163:195])),
             binary_to_dec.strbin_to_dec(str(data[163:195]))),
            ("Reg 3", str(data[195:227]), binary_to_dec.strbin_to_udec(str(data[195:227])),
             binary_to_dec.strbin_to_dec(str(data[195:227]))),
            ("Reg 4", str(data[227:259]), binary_to_dec.strbin_to_udec(str(data[227:259])),
             binary_to_dec.strbin_to_dec(str(data[227:259]))),
            
            ("Reg 5", str(data[259:291]), binary_to_dec.strbin_to_udec(str(data[259:291])),
             binary_to_dec.strbin_to_dec(str(data[259:291]))),
            
            ("Reg 6", str(data[291:323]), binary_to_dec.strbin_to_udec(str(data[291:323])),
             binary_to_dec.strbin_to_dec(str(data[291:323]))),
            
            ("Reg 7", str(data[323:355]), binary_to_dec.strbin_to_udec(str(data[323:355])),
             binary_to_dec.strbin_to_dec(str(data[323:355]))),
            
            ("Reg 8", str(data[355:387]), binary_to_dec.strbin_to_udec(str(data[355:387])),
             binary_to_dec.strbin_to_dec(str(data[355:387]))),
            
            ("Reg 9", str(data[387:419]), binary_to_dec.strbin_to_udec(str(data[387:419])),
             binary_to_dec.strbin_to_dec(str(data[387:419]))),
            
            ("Reg 10", str(data[419:451]), binary_to_dec.strbin_to_udec(str(data[419:451])),
             binary_to_dec.strbin_to_dec(str(data[419:451]))),
            
            ("Reg 11", str(data[451:483]), binary_to_dec.strbin_to_udec(str(data[451:483])),
             binary_to_dec.strbin_to_dec(str(data[451:483]))),
            
            ("Reg 12", str(data[483:515]), binary_to_dec.strbin_to_udec(str(data[483:515])),
             binary_to_dec.strbin_to_dec(str(data[483:515]))),
            
            ("Reg 13", str(data[515:547]), binary_to_dec.strbin_to_udec(str(data[515:547])),
             binary_to_dec.strbin_to_dec(str(data[515:547]))),
            
            ("Reg 14", str(data[547:579]), binary_to_dec.strbin_to_udec(str(data[547:579])),
             binary_to_dec.strbin_to_dec(str(data[547:579]))),
            
            ("Reg 15", str(data[579:611]), binary_to_dec.strbin_to_udec(str(data[579:611])),
             binary_to_dec.strbin_to_dec(str(data[579:611]))),
            
            ("Reg 16", str(data[611:643]), binary_to_dec.strbin_to_udec(str(data[611:643])),
             binary_to_dec.strbin_to_dec(str(data[611:643]))),
            
            ("Reg 17", str(data[643:675]), binary_to_dec.strbin_to_udec(str(data[643:675])),
             binary_to_dec.strbin_to_dec(str(data[643:675]))),
            
            ("Reg 18", str(data[675:707]), binary_to_dec.strbin_to_udec(str(data[675:707])),
             binary_to_dec.strbin_to_dec(str(data[675:707]))),
            
            ("Reg 19", str(data[707:739]), binary_to_dec.strbin_to_udec(str(data[707:739])),
             binary_to_dec.strbin_to_dec(str(data[707:739]))),
            
            ("Reg 20", str(data[739:771]), binary_to_dec.strbin_to_udec(str(data[739:771])),
             binary_to_dec.strbin_to_dec(str(data[739:771]))),
            
            ("Reg 21", str(data[771:803]), binary_to_dec.strbin_to_udec(str(data[771:803])),
             binary_to_dec.strbin_to_dec(str(data[771:803]))),
            
            ("Reg 22", str(data[803:835]), binary_to_dec.strbin_to_udec(str(data[803:835])),
             binary_to_dec.strbin_to_dec(str(data[803:835]))),
            
            ("Reg 23", str(data[835:867]), binary_to_dec.strbin_to_udec(str(data[835:867])),
             binary_to_dec.strbin_to_dec(str(data[835:867]))),
            
            ("Reg 24", str(data[867:899]), binary_to_dec.strbin_to_udec(str(data[867:899])),
             binary_to_dec.strbin_to_dec(str(data[867:899]))),
            
            ("Reg 25", str(data[899:931]), binary_to_dec.strbin_to_udec(str(data[899:931])),
             binary_to_dec.strbin_to_dec(str(data[899:931]))),
            
            ("Reg 26", str(data[931:963]), binary_to_dec.strbin_to_udec(str(data[931:963])),
             binary_to_dec.strbin_to_dec(str(data[931:963]))),
            
            ("Reg 27", str(data[963:995]), binary_to_dec.strbin_to_udec(str(data[963:995])),
             binary_to_dec.strbin_to_dec(str(data[963:995]))),
            
            ("Reg 28", str(data[995:1027]), binary_to_dec.strbin_to_udec(str(data[995:1027])),
             binary_to_dec.strbin_to_dec(str(data[995:1027]))),
            
            ("Reg 29", str(data[1027:1059]), binary_to_dec.strbin_to_udec(str(data[1027:1059])),
             binary_to_dec.strbin_to_dec(str(data[1027:1059]))),
            
            ("Reg 30", str(data[1059:1091]), binary_to_dec.strbin_to_udec(str(data[1059:1091])),
             binary_to_dec.strbin_to_dec(str(data[1059:1091]))),
            
            ("Reg 31", str(data[1091:1123]), binary_to_dec.strbin_to_udec(str(data[1091:1123])),
             binary_to_dec.strbin_to_dec(str(data[1091:1123])))
        ]

        self.step1_input_tuples = []
        self.step1_input_tuples = [
            ("PC", binary_to_dec.strbin_to_udec(str(data[34:66]))),
            ("Instruccion (binary)", str(data[66:98])),
            ("Instruccion (assembly code)", str(data[66:98])),
            ("Stop Pipe", str(data[98]))
        ]
        self.step1_output_tuples = []
        
        self.step2_input_tuples = []
        self.step2_input_tuples = [ 
            ("RT", binary_to_dec.strbin_to_udec(str(data[1123:1128]))),
            ("RD", binary_to_dec.strbin_to_udec(str(data[1128:1133]))),
            ("RS", binary_to_dec.strbin_to_udec(str(data[1133:1138]))),
            ("Sign Exten", binary_to_dec.strbin_to_udec(str(data[1138:1170]))),
            ("Reg RS", binary_to_dec.strbin_to_udec(str(data[1170:1202]))),
            ("Reg RT", binary_to_dec.strbin_to_udec(str(data[1202:1234]))),
            ("PC", str(data[1234:1266])),
            ("PC jump", str(data[1266:1298])),
            ("OP", str(data[1298:1304])),
            ("RegDest", binary_to_dec.strbin_to_udec(str(data[1304]))),
            ("MemRead", binary_to_dec.strbin_to_udec(str(data[1305]))),
            ("MemWrite", binary_to_dec.strbin_to_udec(str(data[1306]))),
            ("MemToReg", binary_to_dec.strbin_to_udec(str(data[1307]))),
            ("ALUop", str(data[1308:1312])),
            ("ALUsrc", binary_to_dec.strbin_to_udec(str(data[1312]))),
            ("RegWrite", binary_to_dec.strbin_to_udec(str(data[1313]))),   
            ("Shmat", binary_to_dec.strbin_to_udec(str(data[1314]))),
            ("Load Store type", str(data[1315:1318])),
            ("Stall", binary_to_dec.strbin_to_udec(str(data[1318]))),
            ("Stop Pipe", str(data[1319]))

        ]
        self.step2_output_tuples = []
        
        self.step3_input_tuples = []
        self.step3_input_tuples = [ 
            ("Jump", binary_to_dec.strbin_to_udec(str(data[1320:1352]))),
            ("PC to Reg", binary_to_dec.strbin_to_dec(str(data[1352:1384]))),
            ("ALU result (signed)", binary_to_dec.strbin_to_dec(str(data[1384:1416]))),
            ("ALU result (unsigned)", binary_to_dec.strbin_to_udec(str(data[1384:1416]))),
            ("ALU result (binary)", str(data[1384:1416])),

            ("RT reg", binary_to_dec.strbin_to_dec(str(data[1416:1448]))),
            ("ADDR reg dst", binary_to_dec.strbin_to_udec(str(data[1448:1453]))),

            ("WritePC", binary_to_dec.strbin_to_udec(str(data[1453]))),
            ("Take", binary_to_dec.strbin_to_udec(str(data[1454]))),
            ("RegWrite", binary_to_dec.strbin_to_udec(str(data[1455]))),
            ("MemToReg", binary_to_dec.strbin_to_udec(str(data[1456]))),
            ("MemWrite", binary_to_dec.strbin_to_udec(str(data[1457]))),
            ("MemRead", binary_to_dec.strbin_to_udec(str(data[1458]))),
            ("Load Store type", binary_to_dec.strbin_to_udec(str(data[1459:1462]))),
            ("Stop Pipe", str(data[1462]))
    
        ]
        self.step3_output_tuples = []
        
        self.step4_input_tuples = []
        i = 0
        while i < 32:
                self.step4_input_tuples += ("Mem "+ str(i), str(data[(i*32)+1463:(i*32)+1463+32])),
                #print "i: "+str((i*32)+1463)+"i+1: " + str((i*32)+1463+32)
                i += 1            
            
        self.step4_output_tuples = []
        
        self.step5_input_tuples = [] 
        self.step5_input_tuples = [ # 2487    2592
            ("Read memory data", binary_to_dec.strbin_to_dec(str(data[2487:2519]))),
            ("ALU result", binary_to_dec.strbin_to_dec(str(data[2519:2551]))),
            ("ADDR Reg dst", str(data[2551:2556])),
            ("PC to Reg", str(data[2556:2588])),
            ("WritePC", binary_to_dec.strbin_to_udec(str(data[2588]))),
            ("RegWrite", binary_to_dec.strbin_to_udec(str(data[2589]))),
            ("MemToReg", binary_to_dec.strbin_to_udec(str(data[2590]))),
            ("Stop Pipe", str(data[2591]))

    
        ]
        self.step5_output_tuples = []

        self.pipeline_tuples = []
        self.pipeline_tuples = [
            ("Clock", binary_to_dec.strbin_to_dec(str(data[2487:2519]))),

        ]

    def __on_port_settings(self, event):
        if event is not None:
            self.__stop_thread()
            self.serial.close()
            self.main_frame_statusbar.SetStatusText("Desconectado", 0)
        ok = False
        while not ok:
            with serial_config_dialog.SerialConfigDialog(self, -1, "",
                                                         show=serial_config_dialog.SHOW_BAUDRATE | serial_config_dialog.SHOW_FORMAT | serial_config_dialog.SHOW_FLOW,
                                                         serial=self.serial) as dialog_serial_cfg:
                dialog_serial_cfg.CenterOnParent()
                result = dialog_serial_cfg.ShowModal()

            if result == wx.ID_OK or event is not None:
                try:
                    self.serial.open()
                except serial.SerialException as e:
                    with wx.MessageDialog(self, str(e), "Serial Port Error", wx.OK | wx.ICON_ERROR) as dlg:
                        dlg.ShowModal()
                else:
                    #self.__start_thread()
                    self.SetTitle(
                        "Serial Terminal on %s [%s,%s,%s,%s%s%s]" % (self.serial.portstr, self.serial.baudrate,
                                                                     self.serial.bytesize, self.serial.parity,
                                                                     self.serial.stopbits,
                                                                     ' RTS/CTS' if self.serial.rtscts else '',
                                                                     ' Xon/Xoff' if self.serial.xonxoff else '',))
                    self.main_frame_statusbar.SetStatusText("Conectado", 0)
                    ok = True
            else:
                # on startup, dialog aborted
                self.main_frame_statusbar.SetStatusText("Conectado", 0)
                self.alive.clear()
                ok = True

    def __on_run(self, event):
        char = 2
        char = unichr(char)
        print "Modo fast"
        self.serial.write(char.encode('UTF-8', 'replace'))
        time.sleep(0.5)
        data = []
        for i in range(324):
            data.append("{0:08b}".format(ord(self.serial.read(1))) + "\n")
        for idx,val in enumerate(data):
            data[idx] = val.replace("\n","")
        data_from_fpga = self.merge_list(data)
        self.__update_fields(data_from_fpga)


    def __on_clock(self, event):
        char = 15
        char = unichr(char)
        print "Siguiente step"
        self.serial.write(char.encode('UTF-8', 'replace'))
        time.sleep(0.5)
        data = []
        for i in range(324):
            data.append("{0:08b}".format(ord(self.serial.read(1))) + "\n")
        for idx,val in enumerate(data):
            data[idx] = val.replace("\n","")
        
        data_from_fpga = self.merge_list(data)
        self.__update_fields(data_from_fpga)
    
    def __on_step(self, event):
        char = 3
        char = unichr(char)
        print "Modo step by step"
        self.serial.write(char.encode('UTF-8', 'replace'))
        time.sleep(0.5)
        

    def __on_load(self, event):
        char = 1
        char = unichr(char)
        print "Modo load"
        self.serial.write(char.encode('UTF-8', 'replace'))
        f = open("memoria.mem","r")
        cont = f.read()
        print cont
        cont = cont.replace("\n","")
        send = [cont[i : i+8] for i in range(0, len(cont), 8)]
        send_chr = [chr(int("0b"+i,2)) for i in send]
        for i in range(0, len(send_chr), 4):
            aux = send_chr[i:i+4]
            print aux
            for j in reversed(aux):
                self.serial.write(j)
                #print j
        self.infoLoad("Se cargó con éxito el programa < memoria.mem >")
        print "Programa Cargado"

    def infoLoad(parent, message, caption = 'Información de Load FPGA'):
        dlg = wx.MessageDialog(parent, message, caption, wx.OK | wx.ICON_INFORMATION)
        dlg.ShowModal()
        dlg.Destroy()

    def infoConvert(parent, message, caption = 'Información de Convertir ASM a BIN '):
        dlg = wx.MessageDialog(parent, message, caption, wx.OK | wx.ICON_INFORMATION)
        dlg.ShowModal()
        dlg.Destroy()

    def __on_exit(self, event):
        #self.__stop_thread()
        self.serial.close()
        self.Destroy()

    def __on_help(self, event):
        message = """FUNCIONALIDADES

- MODO FAST: Indicar a la placa que ejecute todas las instrucciones del programa.
- MODO STEP BY STEP: Indicar a la placa que entre en modo step by step.
- STEP: Indicar a la placa que ejecute la siguiente instruccion del programa.
- MODO LOAD: Cargar programa (memoria.mem) a la placa.
- CONVERTIR ASM TO BIN: Aplicacion para convertir programa en ASM a BIN, escribe archivo (memoria.mem).


ATAJOS:

- Port settings: Ctrl+Alt+S
- Run: Ctrl+Shift+F5
- Clock: Ctrl+F5
- Exit: Ctrl+Q
- Help: F1
- About: Ctrl+A"""
        dlg = wx.MessageDialog(self, message, "Ayuda", wx.OK)
        dlg.ShowModal()
        dlg.Destroy()

    def __on_about(self, event):
        message = """Simulador de microprocesador MIPS.
        Autores:
              Diego Garbiglia - diegogarbiglia@gmail.com
              Cesar Morichetti - cesar.morichetti@gmail.com"""
        dlg = wx.MessageDialog(self, message, "Acerca de MIcomPS", wx.OK)
        dlg.ShowModal()
        dlg.Destroy()
    
    def __on_convert(self, event):
        wildcard = "ASM files (*.asm)|*.asm"
        dialog = wx.FileDialog(self, "Abrir archivo ASM", wildcard=wildcard,
                               style=wx.FD_OPEN | wx.FD_FILE_MUST_EXIST)

        if dialog.ShowModal() == wx.ID_CANCEL:
            return

        path = dialog.GetPath()

        if os.path.exists(path):
            print path
            r = open(path, "r")
            f = open( "memoria.mem","w+")
            lineas = r.readlines()
            for linea in lineas:
                linea = linea[:-1]
                salida = mipsdecoder.convert(linea)
                salida = str(salida) + "\n"
                f.write(salida)

            r.close()
            f.close()
            print "Se escribio archivo"
            self.infoLoad("Se convirtió con éxito el programa, se escribio < memoria.mem >")

class Micomps_UI(wx.App):
    def __init__(self):
        wx.App.__init__(self)
        self.main_frame = MicompsFrame(None, wx.ID_ANY, "")
        self.SetTopWindow(self.main_frame)
        self.main_frame.Show()
