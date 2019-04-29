class FifoEndoController < ApplicationController
	layout 'full', only: [:fullquery, :storequery]


	def loadquery
		#sort by usgae times.
		#@scopies_a=Scopy.where(:slabel=>"O").where(:sclass=>"胃鏡").where(:status=>"鏡架上").where.not(:rid=>"").order('usage asc').limit(3)
		#@scopies_b=Scopy.where(:slabel=>"O").where(:sclass=>"膽道鏡").where(:status=>"鏡架上").where.not(:rid=>"").order('usage asc').limit(3)
		#@scopies_c=Scopy.where(:slabel=>"F").where(:sclass=>"胃鏡").where(:status=>"鏡架上").where.not(:rid=>"").order('usage asc').limit(3)
		#@scopies_d=Scopy.where(:slabel=>"F").where(:sclass=>"鼻鏡").where(:status=>"鏡架上").where.not(:rid=>"").order('usage asc').limit(3)
		#@scopies_e=Scopy.where(:slabel=>"O").where(:sclass=>"大腸鏡").where(:status=>"鏡架上").where.not(:rid=>"").order('usage asc').limit(3)
		#@scopies_f=Scopy.where(:slabel=>"F").where(:sclass=>"大腸鏡").where(:status=>"鏡架上").where.not(:rid=>"").order('usage asc').limit(3)
  	
		#sort by save time.
		@scopies=Worksense.all.joins(:scopy)
		@scopies=@scopies.select('distinct rid, sid, sname, sclass, status, max(begindate+begintime)').group('rid, sid, sname, sclass, status').order('max(begindate+begintime) asc')
		@scopies_a=@scopies.where("slabel='O' and sclass='胃鏡' and status='鏡架上' and rid!=''").limit(3)
		@scopies_b=@scopies.where("slabel='O' and sclass='膽道鏡' and status='鏡架上' and rid!=''").limit(3)
		@scopies_c=@scopies.where("slabel='F' and sclass='胃鏡' and status='鏡架上' and rid!=''").limit(3)
		@scopies_d=@scopies.where("slabel='F' and sclass='鼻鏡' and status='鏡架上' and rid!=''").limit(3)
		@scopies_e=@scopies.where("slabel='O' and sclass='大腸鏡' and status='鏡架上' and rid!=''").limit(3)
		@scopies_f=@scopies.where("slabel='F' and sclass='大腸鏡' and status='鏡架上' and rid!=''").limit(3)
  	

		@carbinet=Carbinet.where('number=1').order('savedate desc, savetime desc').limit(1)
		@temperature_1=@carbinet[0][:temperature]
		@humidity_1=@carbinet[0][:humidity]

		@carbinet=Carbinet.where('number=2').order('savedate desc, savetime desc').limit(1)
		@temperature_2=@carbinet[0][:temperature]
		@humidity_2=@carbinet[0][:humidity]

		@carbinet=Carbinet.where('number=3').order('savedate desc, savetime desc').limit(1)
		@temperature_3=@carbinet[0][:temperature]
		@humidity_3=@carbinet[0][:humidity]

		@carbinet=Carbinet.where('number=4').order('savedate desc, savetime desc').limit(1)
		@temperature_4=@carbinet[0][:temperature]
		@humidity_4=@carbinet[0][:humidity]

		@carbinet=Carbinet.where('number=5').order('savedate desc, savetime desc').limit(1)
		@temperature_5=@carbinet[0][:temperature]
		@humidity_5=@carbinet[0][:humidity]

		@carbinet=Carbinet.where('number=6').order('savedate desc, savetime desc').limit(1)
		@temperature_6=@carbinet[0][:temperature]
		@humidity_6=@carbinet[0][:humidity]
  	end


	def query
		loadquery
	end

	def fullquery
		loadquery
	end


	def storequery
		@results_where=Array.new


		#init. @xieyinghua
		d_3=(Date.today-3).strftime("%Y/%m/%d")
		d_7=(Date.today-7).strftime("%Y/%m/%d")
		t_now=Time.now.strftime("%H:%M:%S")

		#檢查每隻內視鏡三天內有無使用的記錄，沒有的話就再確認七天內有無使用的記錄，以分類出有用、三天沒用、七天沒用的狀況並出報表. @xieyinghua
		@ot=0
		@scopies=Scopy.all
		@scopies=@scopies.where("status!='維修中' and status!='已停用' and rid!='000000'")
		@scopies=@scopies.order('sid asc')
		@scopies.each(){ |scopie|
			@rfbarcodes3=RfBarcode.all
			@rfbarcodes3=@rfbarcodes3.where("rid='#{scopie.rid}'")
			@rfbarcodes3=@rfbarcodes3.where("scandate+scantime>'#{d_3} #{t_now}'")
			@rfbarcodes3=@rfbarcodes3.limit(1)

			#檢查三天內有沒用. @xieyinghua
			if @rfbarcodes3.count==0
				@rfbarcodes7=RfBarcode.all
				@rfbarcodes7=@rfbarcodes7.where("rid='#{scopie.rid}'")
				@rfbarcodes7=@rfbarcodes7.where("scandate+scantime>'#{d_7} #{t_now}'")
				@rfbarcodes7=@rfbarcodes7.limit(1)

				#在做最終判斷前，把這個內視鏡最後一次使用的日期時間存下來. @xieyinghua
				@rflasttime=RfBarcode.all
				@rflasttime=@rflasttime.where("rid='#{scopie.rid}'")
				@rflasttime=@rflasttime.order('scandate desc, scantime desc')
				@rflasttime=@rflasttime.limit(1)
				if @rflasttime.count==0
					lasttime=''
				else
					lasttime=@rflasttime[0][:scandate].strftime("%Y/%m/%d")+' '+@rflasttime[0][:scantime].strftime("%H:%M:%S")
				end

				#檢查七天內有沒用. @xieyinghua
				if @rfbarcodes7.count==0
					@results_where<<{
						:sid=>scopie.sid,
						:sname=>scopie.sname,
						:sclass=>scopie.sclass,
						:tag=>'七天未使用',
						:lasttime=>lasttime
					}
				else
					@results_where<<{
						:sid=>scopie.sid,
						:sname=>scopie.sname,
						:sclass=>scopie.sclass,
						:tag=>'三天未使用',
						:lasttime=>lasttime
					}
				end
				@ot+=1
			end
		}
		@results_where=@results_where.sort_by{ |h| h[:lasttime]  }



		@carbinet=Carbinet.where('number=1').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_1=@carbinet[0][:temperature]
			@humidity_1=@carbinet[0][:humidity]
		else
			@temperature_1=0
			@humidity_1=0
		end

		@carbinet=Carbinet.where('number=2').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_2=@carbinet[0][:temperature]
			@humidity_2=@carbinet[0][:humidity]
		else
			@temperature_2='00.0'
			@humidity_2='00.0'
		end

		@carbinet=Carbinet.where('number=3').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_3=@carbinet[0][:temperature]
			@humidity_3=@carbinet[0][:humidity]
		else
			@temperature_3='00.0'
			@humidity_3='00.0'
		end

		@carbinet=Carbinet.where('number=4').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_4=@carbinet[0][:temperature]
			@humidity_4=@carbinet[0][:humidity]
		else
			@temperature_4='00.0'
			@humidity_4='00.0'
		end

		@carbinet=Carbinet.where('number=5').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_5=@carbinet[0][:temperature]
			@humidity_5=@carbinet[0][:humidity]
		else
			@temperature_5='00.0'
			@humidity_5='00.0'
		end

		@carbinet=Carbinet.where('number=6').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_6=@carbinet[0][:temperature]
			@humidity_6=@carbinet[0][:humidity]
		else
			@temperature_6='00.0'
			@humidity_6='00.0'
		end

		@carbinet=Carbinet.where('number=7').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_7=@carbinet[0][:temperature]
			@humidity_7=@carbinet[0][:humidity]
		else
			@temperature_7='00.0'
			@humidity_7='00.0'
		end

		@carbinet=Carbinet.where('number=8').order('savedate desc, savetime desc').limit(1)
		if @carbinet[0]!=nil
			@temperature_8=@carbinet[0][:temperature]
			@humidity_8=@carbinet[0][:humidity]
		else
			@temperature_8='00.0'
			@humidity_8='00.0'
		end
	end
end
