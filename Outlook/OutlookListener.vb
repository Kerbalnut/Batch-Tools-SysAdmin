'https://stackoverflow.com/questions/11263483/how-do-i-trigger-a-macro-to-run-after-a-new-mail-is-received-in-outlook

Private WithEvents Items As Outlook.Items 
Private Sub Application_Startup() 
  Dim olApp As Outlook.Application 
  Dim objNS As Outlook.NameSpace 
  Set olApp = Outlook.Application 
  Set objNS = olApp.GetNamespace("MAPI") 
  ' default local Inbox
  Set Items = objNS.GetDefaultFolder(olFolderInbox).Items 
End Sub
Private Sub Items_ItemAdd(ByVal item As Object) 

  On Error Goto ErrorHandler 
  Dim Msg As Outlook.MailItem 
  If TypeName(item) = "MailItem" Then
    Set Msg = item 
    SavePicturesFromEmail Msg
  End If
ProgramExit: 
  Exit Sub
ErrorHandler: 
  MsgBox Err.Number & " - " & Err.Description 
  Resume ProgramExit 
End Sub

Public Function SavePicturesFromEmail(ByVal Msg As Outlook.MailItem) As Long
  On Error GoTo ErrorHandler

  Dim shell As Object
  Dim attachment As Outlook.Attachment
  Dim desktopPath As String
  Dim folderPath As String
  Dim savePath As String
  Dim fileName As String

  Set shell = CreateObject("WScript.Shell")
  desktopPath = shell.SpecialFolders("Desktop")
  folderPath = desktopPath & "\Outlook Pictures"

  If Dir(folderPath, vbDirectory) = vbNullString Then
    MkDir folderPath
  End If

  For Each attachment In Msg.Attachments
    If IsPictureAttachment(attachment) Then
      fileName = CleanFileName(attachment.FileName)
      savePath = GetAvailableFilePath(folderPath, fileName)
      attachment.SaveAsFile savePath
      SavePicturesFromEmail = SavePicturesFromEmail + 1
    End If
  Next attachment

  Exit Function
ErrorHandler:
  Err.Raise Err.Number, "SavePicturesFromEmail", Err.Description
End Function

Private Function IsPictureAttachment(ByVal attachment As Outlook.Attachment) As Boolean
  Dim fileName As String
  Dim contentType As String

  fileName = LCase$(attachment.FileName)
  On Error Resume Next
  contentType = LCase$(attachment.PropertyAccessor.GetProperty( _
    "http://schemas.microsoft.com/mapi/proptag/0x370e001f"))
  On Error GoTo 0

  IsPictureAttachment = (Left$(contentType, 6) = "image/") _
    Or (Right$(fileName, 4) = ".jpg") _
    Or (Right$(fileName, 5) = ".jpeg") _
    Or (Right$(fileName, 4) = ".png") _
    Or (Right$(fileName, 4) = ".gif") _
    Or (Right$(fileName, 4) = ".bmp") _
    Or (Right$(fileName, 5) = ".tiff") _
    Or (Right$(fileName, 5) = ".webp")
End Function

Private Function CleanFileName(ByVal fileName As String) As String
  Dim invalidCharacter As Variant

  For Each invalidCharacter In Array("\", "/", ":", "*", "?", """", "<", ">", "|")
    fileName = Replace(fileName, invalidCharacter, "_")
  Next invalidCharacter

  If Len(fileName) = 0 Then fileName = "picture"
  CleanFileName = fileName
End Function

Private Function GetAvailableFilePath(ByVal folderPath As String, _
                                      ByVal fileName As String) As String
  Dim baseName As String
  Dim extension As String
  Dim dotPosition As Long
  Dim counter As Long
  Dim candidate As String

  dotPosition = InStrRev(fileName, ".")
  If dotPosition > 1 Then
    baseName = Left$(fileName, dotPosition - 1)
    extension = Mid$(fileName, dotPosition)
  Else
    baseName = fileName
    extension = vbNullString
  End If

  candidate = folderPath & "\" & fileName
  counter = 1
  Do While Len(Dir(candidate)) > 0
    candidate = folderPath & "\" & baseName & " (" & counter & ")" & extension
    counter = counter + 1
  Loop

  GetAvailableFilePath = candidate
End Function
