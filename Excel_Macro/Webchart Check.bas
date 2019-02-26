Attribute VB_Name = "Module11"
' File Name: Webchart check (ReadMe_Font_Graph_ReturnLink).bas
' Description: Make sure the format of the whole spreasheet meets the webchart standard
' Author: Shijie Shi
' Last updated on: 05/21/2016
'
' !!! Please run this code on the first tab of the spreadsheet--the "Read Me" tab
'

Sub Main()
    Application.ScreenUpdating = True
    Dim ws As Worksheet
    CheckReadMe
    FormatFont
    CheckReturnLink
    DisplayA1
End Sub

Sub CheckReadMe()
    ActiveWorkbook.Worksheets(1).Activate
    Sheets(1).Name = "Read Me"
    
    Sheets("Read Me").Select
    With ActiveWorkbook.Sheets("Read Me").Tab
    .Color = 255
    .TintAndShade = 0
    End With
    

    Dim rng As Range
    Dim cell As Range
    
    Set rng = Range("A1", Range("A1").End(xlDown)).Rows
    
    wsNum = 2
    For Each cell In rng
        cell.Select
            If ActiveCell.Hyperlinks.Count = 0 Then
                With Selection.Font
                    .Bold = True
            End With
            End If
            If ActiveCell.Hyperlinks.Count > 0 Then
                ActiveSheet.Hyperlinks.Add Anchor:=Selection, Address:="", SubAddress:=Sheets(wsNum).Name & "!A1", TextToDisplay:=Mid(Sheets(wsNum).Range("A1").Text, 8)
               wsNum = wsNum + 1
            End If
    Next cell

    Cells.Select
    With Selection.Font
        .Name = "Arial"
        .Size = 14
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
    ActiveWindow.Zoom = 70

    With Selection
        .HorizontalAlignment = xlGeneral
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    
    
End Sub

Sub FormatFont()
   
    'Dim starting_ws As Worksheet
    'Set starting_ws = ActiveSheet
    
    For Each ws In ThisWorkbook.Worksheets

        If ws.Index >= 2 Then
            ws.Activate
            Cells.Select
            With Selection.Font
                    .Name = "Arial"
                    .Size = 14
                    .Color = RGB(0, 0, 0)
                    .Strikethrough = False
                    .Superscript = False
                    .Subscript = False
                    .OutlineFont = False
                    .Shadow = False
                    .TintAndShade = 0
                    .ThemeFont = xlThemeFontNone
            End With
            
            With Selection.Interior
                    .Pattern = xlNone
                    .TintAndShade = 0
                    .PatternTintAndShade = 0
            End With
            

            ActiveWindow.Zoom = 70
        
            Cells(1, 1).Select
            With Selection
                .HorizontalAlignment = xlGeneral
                .VerticalAlignment = xlBottom
                .WrapText = False
                .Orientation = 0
                .AddIndent = False
                .IndentLevel = 0
                .ShrinkToFit = False
                .ReadingOrder = xlContext
                .MergeCells = False
            End With
            
            With Selection.Font
                    .Name = "Arial"
                    .Size = 20
                    .Bold = True
                    .Strikethrough = False
                    .Superscript = False
                    .Subscript = False
                    .OutlineFont = False
                    .Shadow = False
                    .TintAndShade = 0
                    .ThemeFont = xlThemeFontNone
            End With

            For i = 1 To ActiveSheet.ChartObjects.Count
                Set Chrt = ActiveSheet.ChartObjects(i)
                With Chrt
                    .Height = 7.418 * 72
                    .Width = 9.955 * 72
                    .Left = Range("A:A").Left
                    .Top = Range("2:2").Top
                End With
            Next i

        End If
    Next
    ActiveWorkbook.Worksheets(1).Activate

End Sub

Sub CheckReturnLink()

    ' Dim starting_ws As Worksheet
    ' Set starting_ws = ActiveSheet
    Dim findRow As Range

    For Each ws In ThisWorkbook.Worksheets
        If ws.Index >= 2 Then
            ws.Activate
            Set findRow = Range("A:A").Find(What:="Return to Read Me", LookIn:=xlValues, LookAt:=xlWhole)
            findRow.Select
            ActiveCell.FormulaR1C1 = "Return to Read Me"
            ActiveCell.Hyperlinks.Add Anchor:=Selection, Address:="", SubAddress:= _
        "'Read Me'!A1"
        
            With Selection.Font
                .Name = "Arial"
                .Size = 14
                .Strikethrough = False
                .Superscript = False
                .Subscript = False
                .OutlineFont = False
                .Shadow = False
                .TintAndShade = 0
                .ThemeFont = xlThemeFontNone
            End With
        End If
    Next
    
    ActiveWorkbook.Worksheets(1).Activate

End Sub

Sub DisplayA1()
        For Each ws In ThisWorkbook.Worksheets
            ws.Activate
            ws.[a1].Select
        Next ws
        ActiveWorkbook.Worksheets(1).Activate
End Sub



