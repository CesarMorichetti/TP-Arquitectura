from components import main_ui


# This program needs to run pyserial and bitstring modules


if __name__ == "__main__":
    view = main_ui.Micomps_UI()
    view.MainLoop()
