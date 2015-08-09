Imports System.Management

Module Module1

[WMIMETHODDESC]        
    Sub Main()

        Dim computerName As String = "localhost"
        Dim conn As ConnectionOptions = Nothing
        Dim scope As ManagementScope
        Dim options As ObjectGetOptions
        Dim path As ManagementPath
        Dim classInstance As ManagementObject
        Dim inParams As ManagementBaseObject
        Dim outParams As ManagementBaseObject

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

            options = New ObjectGetOptions()
            path = New ManagementPath("[WMIPATH]")
            classInstance = New ManagementObject(scope, path, options)
            inParams = classInstance.GetMethodParameters("[WMIMETHOD]")

[VBNETCODEINPARAMS]  
            outParams = classInstance.InvokeMethod("[WMIMETHOD]", inParams, options:=Nothing)
[VBNETCODEOUTPARAMS]

        Catch ex As Exception
            Console.WriteLine(String.Format("Exception: {0} Trace: {1}", ex.Message, ex.StackTrace))

        End Try

        Console.WriteLine("Press Enter to exit.")
        Console.Read()

    End Sub

End Module
