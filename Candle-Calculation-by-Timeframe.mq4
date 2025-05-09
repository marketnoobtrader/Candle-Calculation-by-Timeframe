//+------------------------------------------------------------------+
//|                                      Candle Calculation by Timeframe |
//|                                           Converted from PineScript |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property link ""
#property description "Calculates and displays levels based on candle data with timeframe and offset options"
#property version "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_width1 2
#property indicator_color2 Blue
#property indicator_width2 2

// Input parameters
input ENUM_TIMEFRAMES TimeFrame = PERIOD_D1; // Timeframe selection

// Indicator buffers
double UpperLevelBuffer[];
double LowerLevelBuffer[];

const int Offset = 1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
   {
// Set indicator buffers
    SetIndexBuffer(0, UpperLevelBuffer);
    SetIndexBuffer(1, LowerLevelBuffer);
// Set indicator labels
    SetIndexLabel(0, "Close + Calculation");
    SetIndexLabel(1, "Close - Calculation");
// Set indicator styles
    SetIndexStyle(0, DRAW_LINE);
    SetIndexStyle(1, DRAW_LINE);
// Set indicator name
    IndicatorShortName("CandleCalcTF");
    return (INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
   {
    int limit;
// Calculate the starting bar
    if(prev_calculated == 0)
        limit = rates_total - 1;
    else
        limit = rates_total - prev_calculated;
// Loop through the bars
    for(int i = limit; i >= 0; i--)
       {
        // Get bar index for the selected timeframe with offset applied
        int tfBarIndex = iBarShift(NULL, TimeFrame, time[i]);
        // Get the data from the specified timeframe with offset
        double tfHigh = iHigh(NULL, TimeFrame, tfBarIndex + Offset);
        double tfLow = iLow(NULL, TimeFrame, tfBarIndex + Offset);
        double tfOpen = iOpen(NULL, TimeFrame, tfBarIndex + Offset);
        double tfClose = iClose(NULL, TimeFrame, tfBarIndex + Offset);
        // Perform calculation: abs((H + L) - (O + C))
        double calculation = MathAbs((tfHigh + tfLow) - (tfOpen + tfClose));
        // Calculate upper and lower levels
        UpperLevelBuffer[i] = tfClose + calculation;
        LowerLevelBuffer[i] = tfClose - calculation;
       }
    return (rates_total);
   }
//+------------------------------------------------------------------+
