Imports System.Management

Module Module1

    [WMICLASSDESC]
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
            scope = New ManagementScope(String.Format("\\{0}\[WMINAMESPACE]", computerName), options:=If(conn IsNot Nothing, conn, Nothing))
            scope.Connect()

            query = New ObjectQuery("SELECT * FROM [WMICLASSNAME]")

            Using searcher As New ManagementObjectSearcher(scope, query)

                For Each wmiObject As ManagementObject In searcher.Get()

[VBNETCODE]

                Next wmiObject

            End Using

        Catch ex As Exception
            Console.WriteLine(String.Format("Exception: {0} Trace: {1}", ex.Message, ex.StackTrace))

        End Try

        Console.WriteLine("Press Enter to exit.")
        Console.Read()

    End Sub

End Module
