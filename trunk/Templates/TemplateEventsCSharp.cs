//-----------------------------------------------------------------------------------------------------
//     This code was generated by the Wmi Delphi Code Creator (WDCC) Version [VERSIONAPP]
//     http://code.google.com/p/wmi-delphi-code-creator/
//     Blog http://theroadtodelphi.wordpress.com/wmi-delphi-code-creator/
//     Author Rodrigo Ruz V. (RRUZ) Copyright (C) 2011-2014 
//----------------------------------------------------------------------------------------------------- 
//
//     LIABILITY DISCLAIMER
//     THIS GENERATED CODE IS DISTRIBUTED "AS IS". NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.
//     YOU USE IT AT YOUR OWN RISK. THE AUTHOR NOT WILL BE LIABLE FOR DATA LOSS,
//     DAMAGES AND LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR MISUSING THIS CODE.
//
//----------------------------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Management;
using System.Text;


namespace GetWMI_Info
{
    public class EventWatcherAsync 
    {
        private void WmiEventHandler(object sender, EventArrivedEventArgs e)
        {
[CSHARPEVENTSOUT]  
        }

        public EventWatcherAsync()
        {
            try
            {
                string ComputerName = "localhost";
                string WmiQuery;
                ManagementEventWatcher Watcher;
                ManagementScope Scope;   
             

                if (!ComputerName.Equals("localhost", StringComparison.OrdinalIgnoreCase)) 
                {
                    ConnectionOptions Conn = new ConnectionOptions();
                    Conn.Username  = "";
                    Conn.Password  = "";
                    Conn.Authority = "ntlmdomain:DOMAIN";
                    Scope = new ManagementScope(String.Format("\\\\{0}\\[WMINAMESPACE]", ComputerName), Conn);
                }
                else
                    Scope = new ManagementScope(String.Format("\\\\{0}\\[WMINAMESPACE]", ComputerName), null);
                Scope.Connect();

[CSHARPEVENTSWQL]
                Watcher = new ManagementEventWatcher(Scope, new EventQuery(WmiQuery));
                Watcher.EventArrived += new EventArrivedEventHandler(this.WmiEventHandler);
                Watcher.Start();
                Console.Read();
                Watcher.Stop();
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception {0} Trace {1}", e.Message, e.StackTrace);
            }
                        
        }

        public static void Main(string[] args)
        {
           Console.WriteLine("Listening {0}", "[WMICLASSNAME]");
           Console.WriteLine("Press Enter to exit");
           EventWatcherAsync eventWatcher = new EventWatcherAsync();
           Console.Read();
        }
    }
}

