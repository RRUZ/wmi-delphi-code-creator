Imports System.Management

Namespace GetWmiInfo

    Public NotInheritable Class EventWatcherAsync

        Dim WithEvents watcher As ManagementEventWatcher

        Private Sub Watcher_EventArrived(ByVal sender As Object, ByVal e As EventArrivedEventArgs) Handles watcher.EventArrived

[VBNETEVENTSOUT]

        End Sub

        Public Sub New()

            Console.WriteLine("Listening {0}", "[WMICLASSNAME]")
            Console.WriteLine("Press Enter to exit.")
            Me.Initialize()
            Console.Read()

        End Sub

        Private Sub Initialize()

            Dim computerName As String = "localhost"
            Dim conn As ConnectionOptions = Nothing
            Dim wmiQuery As String
            Dim scope As ManagementScope

            If Not computerName.Equals("localhost", StringComparison.OrdinalIgnoreCase) Then
                conn = New ConnectionOptions With
                    {
                        .Username = "",
                        .Password = "",
                        .Authority = "ntlmdomain:DOMAIN"
                    }
            End If

            Try
                scope = New ManagementScope(String.Format("\\{0}\[WMINAMESPACE]", computerName), options:=If(conn IsNot Nothing, conn, Nothing))
                scope.Connect()

[VBNETEVENTSWQL]

                Me.watcher = New ManagementEventWatcher(scope, New EventQuery(wmiQuery))
                Me.watcher.Start()
                Console.Read()
                Me.watcher.Stop()

            Catch ex As Exception
                Console.WriteLine(String.Format("Exception: {0} Trace: {1}", ex.Message, ex.StackTrace))

            End Try

        End Sub

    End Class

End Namespace
