({
        generateChart : function(component, event, helper) {           
            var params = event.getParam('arguments');
            var checkParameter =  !$A.util.isUndefinedOrNull(component.find("linechart")) 
                                   && !$A.util.isUndefinedOrNull(component.find("linechart").getElement()) 
                                   && !$A.util.isUndefinedOrNull(params)
                                   && !$A.util.isUndefinedOrNull(params.recordData[0])
                                   && !$A.util.isUndefinedOrNull(params.recordData[1])
                                   && !$A.util.isUndefinedOrNull(params.recordData[0].count)
                                   && !$A.util.isUndefinedOrNull(params.recordData[1].count)
                                   && !$A.util.isUndefinedOrNull(params.recordData[0].label)
                                   && !$A.util.isUndefinedOrNull(params.recordData[1].label) ;
            
            if(checkParameter)
            {            
                var chartData =  params.recordData;
                component.set("v.recordData",chartData);
               
                var userCount = [];
                var userLabel = [];
                var userColor = [];    
                for(var i = 0 ; i < chartData.length ;i++){
                    userCount.push(chartData[i].count);
                    userLabel.push(chartData[i].label);
                    userColor.push("#" + Math.random().toString(16).slice(2, 8)) ;
                }    
                
                if(window.pieChart != null){
                    window.pieChart.destroy();
                }
                
                
                var oilCanvas = component.find("linechart").getElement();                  
                var oilData = {
                    labels: userLabel,
                    datasets: [
                        {
                            data: userCount,
                            backgroundColor: userColor
                        }]
                };
                
                 if(chartData[0].count === 0 && chartData[1].count === 0){             
                        var showChartData = component.find('showChartData'); 
                        $A.util.removeClass(showChartData, 'slds-show');
                        $A.util.addClass(showChartData, 'slds-hide');
                        
                        var noChartData = component.find('noChartData'); 
                        $A.util.removeClass(noChartData, 'slds-hide');
                        $A.util.addClass(noChartData, 'slds-show');
                        Chart.defaults.global.legend.display = false;
                    }else{               
                        var showChartDataNoCount = component.find('showChartData'); 
                        $A.util.removeClass(showChartDataNoCount, 'slds-hide');
                        $A.util.addClass(showChartDataNoCount, 'slds-show');
                        
                        var noChartDataNoCount = component.find('noChartData'); 
                        $A.util.removeClass(noChartDataNoCount, 'slds-show');
                        $A.util.addClass(noChartDataNoCount, 'slds-hide');
               }    
                    
                    
                window.pieChart = new Chart(oilCanvas, {
                    type: 'pie',
                    data: oilData,
                    options: {
                       
                        responsive: true,
                        maintainAspectRatio: false,
                        legend: {
                            position: 'right',
                            labels: {
                                fontColor: "#000000",
                                fontSize: 12
                            }
                        }
                    }
                });
            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": $A.get("$Label.c.MBFS_Exception_message")
                });
                toastEvent.fire();
            } 
            
        },
        drawSegmentValues : function(component, event, helper) {           
            var params = event.getParam('arguments');
            var checkParameter =  !$A.util.isUndefinedOrNull(component.find("linechart")) 
                                   && !$A.util.isUndefinedOrNull(component.find("linechart").getElement()) 
                                   && !$A.util.isUndefinedOrNull(params)
                                   && !$A.util.isUndefinedOrNull(params.recordData)  ;
            
            if(checkParameter)
            {
                Chart.defaults.global.legend.display = true;
               
                var chartData =  params.recordData;
                component.set("v.recordData",chartData);
                component.set("v.totalCount",params.totalCount);
                
                var userCount = [];
                var userLabel = [];
                var userColor = [];    
                for(var i = 0 ; i < chartData.length ;i++){
                    userCount.push(chartData[i].count);
                    userLabel.push(chartData[i].label);
                    userColor.push("#" + Math.random().toString(16).slice(2, 8)) ;
                }    
                
                
                var canvasDraw = component.find("linechart").getElement(); 
               
                
                var data = {
                    datasets: [{
                        data: userCount,
                        backgroundColor: userColor
                    }],
                    labels: userLabel
                };
                
               
                var pieOptions = {
                    events: false,
                    animation: {
                        duration: 0,
                        easing: "easeOutQuart",
                        onComplete: function () {
                            var ctx = this.chart.ctx;
                            ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontFamily, 'normal', Chart.defaults.global.defaultFontFamily);
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'bottom';
                            
                            this.data.datasets.forEach(function (dataset) {
                                
                                for (var i = 0; i < dataset.data.length; i++) {
                                    var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model,
                                        total = dataset._meta[Object.keys(dataset._meta)[0]].total,
                                        mid_radius = model.innerRadius + (model.outerRadius - model.innerRadius)/2,
                                        start_angle = model.startAngle,
                                        end_angle = model.endAngle,
                                        mid_angle = start_angle + (end_angle - start_angle)/2;
                                    
                                    var x = mid_radius * Math.cos(mid_angle);
                                    var y = mid_radius * Math.sin(mid_angle);
                                    
                                    ctx.fillStyle = '#fff';
                                    if (i === 3){ // Darker text color for lighter background
                                        ctx.fillStyle = '#444';
                                    }
                                    
                                    ctx.fillText(dataset.data[i], model.x + x, model.y + y);
                                                                    }
                            });  
                            
                        }
                    },
                    responsive: true,
                    
                    maintainAspectRatio: false,
                    legend: {
                        position: 'right',
                        labels: {
                            fontColor: "#000000",
                            fontSize: 12
                        }
                    }
                };
                
               
                
                canvasDraw.width = 400 ;
                canvasDraw.height = 180 ;
                new Chart(canvasDraw, {
                    type: 'pie', // or doughnut
                    data: data,
                    options: pieOptions
                });               
            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": $A.get("$Label.c.MBFS_Exception_message")
                });
                toastEvent.fire();
            } 
        },       
    })