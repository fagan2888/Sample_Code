Attribute VB_Name = "Module11"
' File Name: FormatChart_GEP.txt
' Description: format the chart to meet DECPG GEP standard
' Author: Shijie Shi
' Last updated on: 08/29/2018
'
' Note: Select the chart to be formatted first



Sub FormatGep()

    Set cht = ActiveSheet.Shapes(LTrim(Replace(ActiveChart.Name, ActiveSheet.Name, "")))
    
' Format chart size, border
    ActiveWindow.Zoom = 100

    With cht
        .Height = 7.5 * 72
        .Width = 10 * 72
        .Fill.Visible = msoTrue
        .Fill.ForeColor.RGB = RGB(255, 255, 255)
        .Fill.ForeColor.TintAndShade = 0
        .Fill.ForeColor.Brightness = 0
        .Fill.Transparency = 0
        .Fill.Solid
        .Line.Visible = msoFalse
    End With


' Set up text format
    With cht.Chart.ChartArea.Format.TextFrame2.TextRange.Font
        .NameComplexScript = "Arial"
        .NameFarEast = "Arial"
        .Name = "Arial"
        .Size = 32
        .Bold = msoFalse
        .Fill.ForeColor.RGB = RGB(0, 0, 0)
        .Fill.ForeColor.TintAndShade = 0
        .Fill.ForeColor.Brightness = 0
        .Fill.Transparency = 0
        .Fill.Solid
    End With


' Chart title
    If cht.Chart.HasTitle Then
        
        If cht.Chart.ChartTitle.Text = "Chart Title" Then
            cht.Chart.ChartTitle.Delete
        Else
            cht.Chart.ChartTitle.Format.TextFrame2.TextRange.Font.Size = 32
        End If
        
    End If
    
    
' X-axis
    Set x = cht.Chart.Axes(xlCategory)
    x.MajorTickMark = xlNone
    x.Format.Fill.Visible = msoFalse
    x.TickLabelPosition = xlLow
   
    With x.Format.Line
        .Visible = msoTrue
        .ForeColor.RGB = RGB(0, 0, 0)
        .ForeColor.TintAndShade = 0
        .ForeColor.Brightness = 0
        .Transparency = 0
        .Weight = 0.75
    End With
   
   
' Y-axis
    Set y = cht.Chart.Axes(xlValue)
    y.MajorTickMark = xlNone
    y.Format.Fill.Visible = msoFalse
    y.Format.Line.Visible = msoFalse
    
    If y.HasMajorGridlines Then
        y.MajorGridlines.Delete
    End If
    
    
' Set up color scheme
'    ActiveWorkbook.Theme.ThemeColorScheme.Load ( _
'    "C:\Users\wb531948\AppData\Roaming\Microsoft\Templates\Document Themes\Theme Colors\DECPG.xml" _
'    )
  

End Sub
