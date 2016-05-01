
# Let user put in latitude, then calculate Ra
# let user put in mean temperature, low, high
# let user pick crop coefficient
# then print the reference ET and the ETk

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("ET（蒸発散値: 標準 ETと特定作物 ET）計算機"),
  withMathJax(),
  
  # explain what this is
  
  tags$div(
    HTML(paste("このプログラムは、標準蒸発散値(ET",
               tags$sub("o"),
               ") を、年月日、緯度、その日の最高気温と最低気温を基にしてmm 単位で計算します。算出された
               ET",
               tags$sub("o"), " に、作物係数を乗算すると、
               その作物の蒸発散値（ET",
               tags$sub("c"),"）が求められます。これらの計算はHargreaves の ET",
               tags$sub("o"), " 公式を使って行われます", 
               a("（FAO Crop Evapotranspiration のequation 52を使用）",
                 href = "http://www.fao.org/docrep/X0490E/x0490e07.htm#an%20alternative%20equation%20for%20eto%20when%20weather%20data%20are%20missing"),
               "詳細はこのページ末尾をご覧ください。",
               sep = ""))
  ),
  
  # Sidebar to input necessary data
  
  verticalLayout(
    
    
    
    
    dateInput("date", "年月日:", language = "ja"),
    
    
    numericInput("latitude",
                "緯度：北緯と南緯を区別します。北緯は + の値で表示されます。南緯は - 記号を付けて表示されます。",
                min = -70,
                max = 70,
                value = 35.7,
                step = 0.1),
    
    
    
    numericInput("high", "最高気温(°C)", 25,
                 min = -20, max = 60, step = 0.1),
    
    
    
    numericInput("low", "最低気温(°C)", 15,
                 min = -50, max = 35, step = 0.1),
    
    
    
    numericInput("kC", HTML(paste("作物係数(K", 
                                  tags$sub("c"), ")", sep = "")),
                 0.8, min = 0, max = 1.5, step = 0.01),
    
    
    
    
    # Show the output
    
    h3(textOutput("text1")),
    
    # explain what this is
    hr(),
    helpText('公式52 は \\(ET_{o} = 0.0023(T_{avg} + 17.8)(T_{max} - T_{min})^{0.5}R_{a}\\),
             ここで、 \\(ET_{o}\\) は標準 ET、 \\(T_{avg}\\) は平均気温、
             \\(T_{max}\\) と \\(T_{min}\\) はそれぞれ最高気温と最低気温、
             \\(R_{a}\\) は地球外放射を mm 単位（蒸発と同じ単位）で表したものであり、
             エネルギー単位（メガジュール毎平方メートル）表記ではありません。年月日と緯度が分かれば、
             \\(R_{a}\\) を計算することができます。最高気温と最低気温の差は
             雲量の値として用いられ、これによって地球外からの放射線が
             地上に到達する割合を決定します。'),
    
     helpText(HTML(paste('これらの計算結果を検証したい場合には、 
                         地球外放射の数値表 ',
                    a("(Crop evapotranspiration の Table 2.6)",
                      href = "http://www.fao.org/docrep/x0490e/x0490e0j.htm#annex%202.%20meteorological%20tables"),
                    ' を使用し、地球外放射の値に0.408 を掛けることによって地球外放射の値を蒸発値（mm）に換算します。
                    その値が公式 52 で使用する \\(R_{a}\\) の値となります。 
                    以下のページのコードを参照 ',
                    a("(GitHub)。",
                      href = "https://github.com/micahwoods/ETo_jp"),
                    sep = "")))
    )
  )
)
