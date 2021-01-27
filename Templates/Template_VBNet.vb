Imports System.Management

Module Module1

    Sub Main()

        Dim computerName As String = "localhost"
        Dim conn As ConnectionOptions = Nothing
        Dim scope As ManagementScope
        Dim query As ObjectQuery

        If Not computerName.Equals("localhost", StringComparison.OrdinalIgnoreCase) Then
            conn = New ConnectionOptions With
                {
                    .Username = "",
                    .Password = "",
                    .Authority = "ntlmdomain:DOMAIN"
                }
        End If

        Try
            scope = New ManagementScope(String.Format("\\{0}\root\CIMV2", computerName), options:=If(conn IsNot Nothing, conn, Nothing))
            scope.Connect()

            query = New ObjectQuery("SELECT * FROM Win32_DiskDrive")

            Using searcher As New ManagementObjectSearcher(scope, query)

                For Each wmiObject As ManagementObject In searcher.Get()

                    ' String
                    Console.WriteLine("{0,-35} {1,-40}", "Name", CStr(wmiObject("Name")))

                Next wmiObject

            End Using

        Catch ex As Exception
            Console.WriteLine(String.Format("Exception: {0} Trace: {1}", ex.Message, ex.StackTrace))

        End Try

        Console.WriteLine("Press Enter to exit.")
        Console.Read()

    End Sub

End Module
