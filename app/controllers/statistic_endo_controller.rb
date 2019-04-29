class StatisticEndoController < ApplicationController
	def perusagefrequency

		@results_where=Hash.new

		if params[:search]=='yes'
			#query. @xieyinghua
			@results_where=Worksense.all.joins(:scopy).joins(:site).joins(:patient)
			@results_where=@results_where.where("wid is not null and wid!='NO'")
			@results_where=@results_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@results_where=@results_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@results_where=@results_where.where('scopies.slabel'=>params[:slabel_text]) if params[:slabel_text]!=""
			@results_where=@results_where.where('scopies.sid'=>params[:sid_text]) if params[:sid_text]!=""
			@results_count=@results_where.count
		end
    end
	def allusagefrequency

		@results_where=Hash.new

		if params[:search]=='yes'
			#query. @xieyinghua
			@results_where=Scopy.all
			@results_where=@results_where.where('scopies.slabel'=>params[:slabel_text]) if params[:slabel_text]!=""
			@results_where=@results_where.where('scopies.sid'=>params[:sid_text]) if params[:sid_text]!=""
		end
	end



	#write excel. @xieyinghua
  	def processtime_writeexcel() 
	    # Create a new Excel Worksense
	    if Rails.env.production?
	      @wlink='../processtime.xls'
	      @rlink='../processtime.xls'
	    else
	      @wlink='public/processtime.xls'
	      @rlink='../processtime.xls'
	    end
	    worksense = WriteExcel.new(@wlink)


	    # Add worksheet(s)
	    worksheet  = worksense.add_worksheet

	    # Add and define a format
	    format = worksense.add_format
	    format.set_bold
	    format.set_align('center')
	    format.set_text_warp(true)


	    # write title
	    worksheet.write(0, 0, t(:sortid, :scope=>[:activerecord,:attributes,:worksense]),format)
	    worksheet.write(0, 1, t(:savetime, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 2, t(:sname, :scope=>[:activerecord,:attributes,:scopy]),format)
        worksheet.write(0, 3, t(:pid, :scope=>[:activerecord,:attributes,:patient]),format)
        worksheet.write(0, 4, t(:pname, :scope=>[:activerecord,:attributes,:patient]),format)
        worksheet.write(0, 5, t(:stagedate, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 6, t(:examrole, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 7, t(:washrole, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 8, t(:disinfectionrole, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 9, t(:siteid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 10, t(:washid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 11, t(:disinfectionid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 12, t(:stage1time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 13, t(:stage1endtime, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 14, t(:stage2time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 15, t(:stage3time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 16, t(:stage4time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 17, t(:paytime, :scope=>[:activerecord,:attributes,:worksense]),format)
	    

	    #write body
	    @results_where.each_with_index do |result,i|
	    	row=i+1

	    	worksheet.write(row, 0, row)
	    	worksheet.write(row, 1, @stage[result.id][:savetime])
	        worksheet.write(row, 2, result.scopy.sname)
	        worksheet.write(row, 3, result.patient.pid)
	        worksheet.write(row, 4, result.patient.pname)
	        worksheet.write(row, 5, result.begindate)
	        worksheet.write(row, 6, @stage[result.id][:examrole])
	        worksheet.write(row, 7, @stage[result.id][:washrole])
	        worksheet.write(row, 8, @stage[result.id][:disinfectionrole])
	        worksheet.write(row, 9, result.site.sname)
	        worksheet.write(row, 10, @stage[result.id][:washid])
	        worksheet.write(row, 11, @stage[result.id][:disinfectionid])
	        worksheet.write(row, 12, @stage[result.id][:stage1time])
	        worksheet.write(row, 13, @stage[result.id][:stage1endtime])
	        worksheet.write(row, 14, @stage[result.id][:stage2time])
	        worksheet.write(row, 15, @stage[result.id][:stage3time])
	        worksheet.write(row, 16, @stage[result.id][:stage4time])
	        worksheet.write(row, 17, @stage[result.id][:paytime])
	    end


	    # write to file
	    worksense.close
  	end
	def processtime

		@results_where=Hash.new

		if params[:search]=='yes'
			#query. @xieyinghua
			@results_where=Worksense.all.joins(:scopy).joins(:site).joins(:patient)
			@results_where=@results_where.select('DISTINCT ON (begindate,patient_id,site_id,scopy_id,wid) worksenses.*,scopies.sname,patients.pid,patients.pname,sites.sname')
			@results_where=@results_where.where("sites.sname in ('Room1','Room2','Room3','Room4','Room5','ERCP','外做')")
			@results_where=@results_where.where("wid is not null and wid!='NO'")
			@results_where=@results_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@results_where=@results_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@results_where=@results_where.where('scopies.sid'=>params[:sid_text]) if params[:sid_text]!="" and params[:sid_text]!=nil
			@results_where=@results_where.where('scopies.slabel'=>params[:slabel_text]) if params[:slabel_text]!="" and params[:slabel_text]!=nil
			@results_where=@results_where.where('patients.pid'=>params[:pid_text]) if params[:pid_text]!="" and params[:pid_text]!=nil
			@results_where=@results_where.order('begindate asc')

=begin
			@results_where=@results_where.order('begindate asc, begintime asc')

			
			@not_id=''
			@stage=Hash.new
			@results_where.each(){ |result|
				
				#整合班表，找出檢查室的工作人員
				@schedules_search=Schedule.all
				@schedules_search=@schedules_search.where("site='#{result.site.sname}'")
				@schedules_search=@schedules_search.where("workdate<='#{result.begindate}'")
				@schedules_search=@schedules_search.order('workdate desc')
				if result.begintime.strftime("%T")>='14:00:00'
					@schedules_search=@schedules_search.where("workpart='下午'")
				else
					@schedules_search=@schedules_search.where("workpart='上午'")
				end
				@schedules_search=@schedules_search.limit(1)
				if @schedules_search[0]!=nil
					examrole=@schedules_search[0].uid
				else
					examrole=''
				end


				#如果有設定要找的跟檢人員的id，那麼搜尋到這筆資料的跟檢人員不等同於要找的跟檢人員id的話，就記錄下來這筆資料等下要去掉
				if params[:examrole_text]!="" and examrole!=params[:examrole_text] and params[:examrole_text]!=nil
					@not_id+=(result.id.to_s()+',')
				else


					#計算到消毒室(洗滌機)的時間，並取得機號的編號
					@worksenses_search=Worksense.all.joins(:site)
					@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
					@worksenses_search=@worksenses_search.where("sites.sname like '洗滌機%'")
					@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
					@worksenses_search=@worksenses_search.order('begintime desc')
					if @worksenses_search!=[]
						stage3time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
						#stage4time=(@worksenses_search[0][:begintime]+(50*60)).strftime("%H:%M:%S")
						if @worksenses_search[0][:endtime]==nil
							stage4time=''
						else
							stage4time=@worksenses_search[0][:endtime].strftime("%H:%M:%S")
						end
						disinfectionid=@worksenses_search[0].site[:sname]
					else
						stage3time=''
						stage4time=''
						disinfectionid=''
					end


					#如果有設定要找的洗滌機的名稱，那麼搜尋到這筆資料的洗滌機不等同於要找的洗滌機id的話，就記錄下來這筆資料等下要去掉
					if params[:disinfectionid_text]!="" and disinfectionid!=params[:disinfectionid_text] and params[:disinfectionid_text]!=nil
						@not_id+=(result.id.to_s()+',')
					else


						#計算到檢查室的時間
						stage1time=result.begintime.strftime("%H:%M:%S")
						if result.endtime==nil
							stage1endtime=''
						else
							stage1endtime=result.endtime.strftime("%H:%M:%S")
						end


						#計算到洗淨室(洗滌台)的時間
						@worksenses_search=Worksense.all.joins(:site)
						@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
						@worksenses_search=@worksenses_search.where("sites.sname like '洗滌台%'")
						@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
						@worksenses_search=@worksenses_search.order('begintime desc')
						if @worksenses_search!=[]
							stage2time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
							washid=@worksenses_search[0].site[:sname]
						else
							stage2time=''
							washid=''
						end

						#計算總費時
						if stage1time!='' and stage4time!=''
							paytime=time_diff(Time.parse(stage4time),Time.parse(stage1time))
						else
							paytime='未知'
						end

						#計算距離上次使用的存放時間
						@worksenses_search=Worksense.all.joins(:site)
						@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id} and (begindate+begintime)<'#{result.begindate} #{result.begintime.strftime("%T")}'")
						@worksenses_search=@worksenses_search.where("wid is not null and wid!='NO'")
						@worksenses_search=@worksenses_search.order('begindate desc, begintime desc')
						@worksenses_search=@worksenses_search.limit(1)
						if @worksenses_search[0]!=nil
							if @worksenses_search[0].site.sname=~/洗滌機*./
								#如果最後一筆記錄的時間是洗滌機，那就把最後一次的時間往後延50分鐘後，再計算時間差
								savetime=time_diff(Time.parse("#{@worksenses_search[0].begindate} #{@worksenses_search[0].begintime.strftime('%T')}")+50.minute,Time.parse("#{result.begindate} #{result.begintime.strftime('%T')}"))
							else
								#如果最後一筆記錄的時間是其它的時間，就直接計算時間差
								savetime=time_diff(Time.parse("#{@worksenses_search[0].begindate} #{@worksenses_search[0].begintime.strftime('%T')}"),Time.parse("#{result.begindate} #{result.begintime.strftime('%T')}"))
							end
						else
							savetime=''
						end


						#整合班表，找出清洗室的工作人員
						@schedules_search=Schedule.all
						if washid!=nil and washid!='洗滌台'
							@schedules_search=@schedules_search.where("site like '#{washid}'")
						else
							@schedules_search=@schedules_search.where("site like '洗滌台%'")
						end
						@schedules_search=@schedules_search.where("workdate='#{result.begindate}'")
						@schedules_search=@schedules_search.order('workdate desc')
						if stage2time>='14:00:00'
							@schedules_search=@schedules_search.where("workpart='下午'")
						elsif stage2time==''
							@schedules_search=@schedules_search.limit(0)
						else
							@schedules_search=@schedules_search.where("workpart='上午'")
						end
						if @schedules_search[0]!=nil
							washrole=@schedules_search[0].uid
							@schedules_search.each_with_index(){|data,i|
								washrole+=(','+data.uid)	if(i!=0)
							}
						else
							washrole=''
						end

						#整合班表，找出消毒室的工作人員
						@schedules_search=Schedule.all
						@schedules_search=@schedules_search.where("site like '洗滌機%'")
						@schedules_search=@schedules_search.where("workdate='#{result.begindate}'")
						@schedules_search=@schedules_search.order('workdate desc')
						if stage3time>='14:00:00'
							@schedules_search=@schedules_search.where("workpart='下午'")
						elsif stage3time==''
							@schedules_search=@schedules_search.limit(0)
						else
							@schedules_search=@schedules_search.where("workpart='上午'")
						end
						if @schedules_search[0]!=nil
							disinfectionrole=@schedules_search[0].uid 
						else
							disinfectionrole=''
						end


						#組合顯示用的hash
						@stage[result.id]={
							:savetime=>savetime,
							:examrole=>examrole,
							:washrole=>washrole,
							:washid=>washid,
							:disinfectionrole=>disinfectionrole,
							:disinfectionid=>disinfectionid,
							:stage1time=>stage1time, 
							:stage1endtime=>stage1endtime, 
							:stage2time=>stage2time, 
							:stage3time=>stage3time, 
							:stage4time=>stage4time, 
							:paytime=>paytime
						}
					end
				end
			}



			#處理沒有頭，從清洗室開始的資料
			#query. @xieyinghua
			@results_where=Worksense.all.joins(:scopy).joins(:site).joins(:patient)
			@results_where=@results_where.select('DISTINCT ON (begindate,site_id,scopy_id,wid) worksenses.*,scopies.sname,sites.sname')
			@results_where=@results_where.where("sites.sname like '洗淨台%'")
			@results_where=@results_where.where("wid='NO'")
			@results_where=@results_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@results_where=@results_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@results_where=@results_where.where('scopies.sid'=>params[:sid_text]) if params[:sid_text]!="" and params[:sid_text]!=nil
			@results_where=@results_where.where('scopies.slabel'=>params[:slabel_text]) if params[:slabel_text]!="" and params[:slabel_text]!=nil
			@results_where=@results_where.where('patients.pid'=>params[:pid_text]) if params[:pid_text]!="" and params[:pid_text]!=nil
			@results_where=@results_where.order('begindate asc, begintime asc')
=end
			
			@not_id=''
			@stage=Hash.new
			@results_where.each(){ |result|
				
				#整合班表，找出檢查室的工作人員
				@schedules_search=Schedule.all
				@schedules_search=@schedules_search.where("site='#{result.site.sname}'")
				@schedules_search=@schedules_search.where("workdate<='#{result.begindate}'")
				@schedules_search=@schedules_search.order('workdate desc')
				if result.begintime.strftime("%T")>='14:00:00'
					@schedules_search=@schedules_search.where("workpart='下午'")
				else
					@schedules_search=@schedules_search.where("workpart='上午'")
				end
				@schedules_search=@schedules_search.limit(1)
				if @schedules_search[0]!=nil
					examrole=@schedules_search[0].uid
				else
					examrole=''
				end


				#如果有設定要找的跟檢人員的id，那麼搜尋到這筆資料的跟檢人員不等同於要找的跟檢人員id的話，就記錄下來這筆資料等下要去掉
				if params[:examrole_text]!="" and examrole!=params[:examrole_text] and params[:examrole_text]!=nil
					@not_id+=(result.id.to_s()+',')
				else


					#計算到消毒室(洗滌機)的時間，並取得機號的編號
					@worksenses_search=Worksense.all.joins(:site)
					@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
					@worksenses_search=@worksenses_search.where("sites.sname like '洗滌機%'")
					@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
					@worksenses_search=@worksenses_search.order('begintime desc')
					if @worksenses_search!=[]
						stage3time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
						#stage4time=(@worksenses_search[0][:begintime]+(50*60)).strftime("%H:%M:%S")
						if @worksenses_search[0][:endtime]==nil
							stage4time=''
						else
							stage4time=@worksenses_search[0][:endtime].strftime("%H:%M:%S")
						end
						disinfectionid=@worksenses_search[0].site[:sname]
					else
						stage3time=''
						stage4time=''
						disinfectionid=''
					end


					#如果有設定要找的洗滌機的名稱，那麼搜尋到這筆資料的洗滌機不等同於要找的洗滌機id的話，就記錄下來這筆資料等下要去掉
					if params[:disinfectionid_text]!="" and disinfectionid!=params[:disinfectionid_text] and params[:disinfectionid_text]!=nil
						@not_id+=(result.id.to_s()+',')
					else


						#計算到檢查室的時間
						stage1time=result.begintime.strftime("%H:%M:%S")
						if result.endtime==nil
							stage1endtime=''
						else
							stage1endtime=result.endtime.strftime("%H:%M:%S")
						end


						#計算到洗淨室(洗滌台)的時間
						@worksenses_search=Worksense.all.joins(:site)
						@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
						@worksenses_search=@worksenses_search.where("sites.sname like '洗滌台%'")
						@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
						@worksenses_search=@worksenses_search.order('begintime desc')
						if @worksenses_search!=[]
							stage2time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
							washid=@worksenses_search[0].site[:sname]
						else
							stage2time=''
							washid=''
						end

						#計算總費時
						if stage1time!='' and stage4time!=''
							paytime=time_diff(Time.parse(stage4time),Time.parse(stage1time))
						else
							paytime='未知'
						end

						#計算距離上次使用的存放時間
						@worksenses_search=Worksense.all.joins(:site)
						@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id} and (begindate+begintime)<'#{result.begindate} #{result.begintime.strftime("%T")}'")
						@worksenses_search=@worksenses_search.where("wid is not null and wid!='NO'")
						@worksenses_search=@worksenses_search.order('begindate desc, begintime desc')
						@worksenses_search=@worksenses_search.limit(1)
						if @worksenses_search[0]!=nil
							if @worksenses_search[0].site.sname=~/洗滌機*./
								#如果最後一筆記錄的時間是洗滌機，那就把最後一次的時間往後延50分鐘後，再計算時間差
								savetime=time_diff(Time.parse("#{@worksenses_search[0].begindate} #{@worksenses_search[0].begintime.strftime('%T')}")+50.minute,Time.parse("#{result.begindate} #{result.begintime.strftime('%T')}"))
							else
								#如果最後一筆記錄的時間是其它的時間，就直接計算時間差
								savetime=time_diff(Time.parse("#{@worksenses_search[0].begindate} #{@worksenses_search[0].begintime.strftime('%T')}"),Time.parse("#{result.begindate} #{result.begintime.strftime('%T')}"))
							end
						else
							savetime=''
						end


						#整合班表，找出清洗室的工作人員
						@schedules_search=Schedule.all
						if washid!=nil and washid!='洗滌台'
							@schedules_search=@schedules_search.where("site like '#{washid}'")
						else
							@schedules_search=@schedules_search.where("site like '洗滌台%'")
						end
						@schedules_search=@schedules_search.where("workdate='#{result.begindate}'")
						@schedules_search=@schedules_search.order('workdate desc')
						if stage2time>='14:00:00'
							@schedules_search=@schedules_search.where("workpart='下午'")
						elsif stage2time==''
							@schedules_search=@schedules_search.limit(0)
						else
							@schedules_search=@schedules_search.where("workpart='上午'")
						end
						if @schedules_search[0]!=nil
							washrole=@schedules_search[0].uid
							@schedules_search.each_with_index(){|data,i|
								washrole+=(','+data.uid)	if(i!=0)
							}
						else
							washrole=''
						end

						#整合班表，找出消毒室的工作人員
						@schedules_search=Schedule.all
						@schedules_search=@schedules_search.where("site like '洗滌機%'")
						@schedules_search=@schedules_search.where("workdate='#{result.begindate}'")
						@schedules_search=@schedules_search.order('workdate desc')
						if stage3time>='14:00:00'
							@schedules_search=@schedules_search.where("workpart='下午'")
						elsif stage3time==''
							@schedules_search=@schedules_search.limit(0)
						else
							@schedules_search=@schedules_search.where("workpart='上午'")
						end
						if @schedules_search[0]!=nil
							disinfectionrole=@schedules_search[0].uid 
						else
							disinfectionrole=''
						end


						#組合顯示用的hash
						@stage[result.id]={
							:savetime=>savetime,
							:examrole=>examrole,
							:washrole=>washrole,
							:washid=>washid,
							:disinfectionrole=>disinfectionrole,
							:disinfectionid=>disinfectionid,
							:stage1time=>stage1time, 
							:stage1endtime=>stage1endtime, 
							:stage2time=>stage2time, 
							:stage3time=>stage3time, 
							:stage4time=>stage4time, 
							:paytime=>paytime
						}
					end
				end
			}




			#如果有要排除的id，那麼就在這裡排除掉
			#if @not_id!=''
			#	@not_id=not_id[0..(@not_id.length-2)]
			#	@results_where=@results_where.where("worksenses.id not in (#{@not_id})")
			#end
			

			#write result to file. @xieyinghua
			processtime_writeexcel()
		else
			#依客戶要求填入預設的日期為當日日期
			params[:begindate_text]=Date.today.strftime("%Y-%m-%d")
			params[:enddate_text]=Date.today.strftime("%Y-%m-%d")
		end
	end



	#write excel. @xieyinghua
  	def withreport_writeexcel() 
	    # Create a new Excel Worksense
	    if Rails.env.production?
	      @wlink='../withreport.xls'
	      @rlink='../withreport.xls'
	    else
	      @wlink='public/withreport.xls'
	      @rlink='../withreport.xls'
	    end
	    worksense = WriteExcel.new(@wlink)


	    # Add worksheet(s)
	    worksheet  = worksense.add_worksheet

	    # Add and define a format
	    format = worksense.add_format
	    format.set_bold
	    format.set_align('center')
	    format.set_text_warp(true)


	    # write title
	    worksheet.write(0, 0, t(:sortid, :scope=>[:activerecord,:attributes,:worksense]),format)
	    worksheet.write(0, 1, t(:savetime, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 2, t(:sname, :scope=>[:activerecord,:attributes,:scopy]),format)
        worksheet.write(0, 3, t(:pid, :scope=>[:activerecord,:attributes,:patient]),format)
        worksheet.write(0, 4, t(:pname, :scope=>[:activerecord,:attributes,:patient]),format)
        worksheet.write(0, 5, t(:stagedate, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 6, t(:studydr, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 7, t(:examrole, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 8, t(:washrole, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 9, t(:disinfectionrole, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 10, t(:siteid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 11, t(:washid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 12, t(:disinfectionid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 13, t(:stage1time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 14, t(:stage1endtime, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 15, t(:stage2time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 16, t(:stage3time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 17, t(:stage4time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 18, t(:paytime, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 19, t(:wid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 20, t(:examtypeid, :scope=>[:activerecord,:attributes,:worksense]),format)
	    


	    #write body
	    @results_where.each_with_index do |result,i|
	    	row=i+1

	    	worksheet.write(row, 0, row)
	    	worksheet.write(row, 1, @stage[result.id][:savetime])
	        worksheet.write(row, 2, result.scopy.sname)
	        worksheet.write(row, 3, result.patient.pid)
	        worksheet.write(row, 4, result.patient.pname)
	        worksheet.write(row, 5, result.begindate)
	        worksheet.write(row, 6, result.examine.studydr)
	        worksheet.write(row, 7, @stage[result.id][:examrole])
	        worksheet.write(row, 8, @stage[result.id][:washrole])
	        worksheet.write(row, 9, @stage[result.id][:disinfectionrole])
	        worksheet.write(row, 10, result.site.sname)
	        worksheet.write(row, 11, @stage[result.id][:washid])
	        worksheet.write(row, 12, @stage[result.id][:disinfectionid])
	        worksheet.write(row, 13, @stage[result.id][:stage1time])
	        worksheet.write(row, 14, @stage[result.id][:stage1endtime])
	        worksheet.write(row, 15, @stage[result.id][:stage2time])
	        worksheet.write(row, 16, @stage[result.id][:stage3time])
	        worksheet.write(row, 17, @stage[result.id][:stage4time])
	        worksheet.write(row, 18, @stage[result.id][:paytime])
	        worksheet.write(row, 19, result.wid)
	        worksheet.write(row, 20, result.examine.typeid)
	    end


	    # write to file
	    worksense.close
  	end
	def withreport

		@results_where=Hash.new

		if params[:search]=='yes'
			#query. @xieyinghua
			@results_where=Worksense.all.joins(:scopy).joins(:site).joins(:patient).joins(:examine)
			@results_where=@results_where.select('DISTINCT ON (begindate,patient_id,site_id,scopy_id,examine_id,wid) worksenses.*,scopies.sname,patients.pid,patients.pname,sites.sname,examines.studydr,examines.typeid')
			@results_where=@results_where.where("sites.sname in ('Room1','Room2','Room3','Room4','Room5','ERCP','外做')")
			@results_where=@results_where.where("wid is not null and wid!='NO'")
			@results_where=@results_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@results_where=@results_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@results_where=@results_where.where('scopies.sid'=>params[:sid_text]) if params[:sid_text]!="" and params[:sid_text]!=nil
			@results_where=@results_where.where('scopies.slabel'=>params[:slabel_text]) if params[:slabel_text]!="" and params[:slabel_text]!=nil
			@results_where=@results_where.where('patients.pid'=>params[:pid_text]) if params[:pid_text]!="" and params[:pid_text]!=nil
			@results_where=@results_where.where('examines.studydr'=>params[:studydr_text]) if params[:studydr_text]!="" and params[:studydr_text]!=nil
			@results_where=@results_where.order('begindate asc')

			
			@not_id=''
			@stage=Hash.new
			@results_where.each(){ |result|

				
				#整合班表，找出檢查室的工作人員
				@schedules_search=Schedule.all
				@schedules_search=@schedules_search.where("site='#{result.site.sname}'")
				@schedules_search=@schedules_search.where("workdate<='#{result.begindate}'")
				@schedules_search=@schedules_search.order('workdate desc')
				if result.begintime.strftime("%T")>='14:00:00'
					@schedules_search=@schedules_search.where("workpart='下午'")
				else
					@schedules_search=@schedules_search.where("workpart='上午'")
				end
				@schedules_search=@schedules_search.limit(1)
				if @schedules_search[0]!=nil
					examrole=@schedules_search[0].uid
				else
					examrole=''
				end


				#如果有設定要找的跟檢人員的id，那麼搜尋到這筆資料的跟檢人員不等同於要找的跟檢人員id的話，就記錄下來這筆資料等下要去掉
				if params[:examrole_text]!="" and examrole!=params[:examrole_text] and params[:examrole_text]!=nil
					@not_id+=(result.id.to_s()+',')
				else


					#計算到消毒室(洗滌機)的時間，並取得機號的編號
					@worksenses_search=Worksense.all.joins(:site)
					@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
					@worksenses_search=@worksenses_search.where("sites.sname like '洗滌機%'")
					@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
					@worksenses_search=@worksenses_search.order('begintime desc')
					if @worksenses_search!=[]
						stage3time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
						#stage4time=(@worksenses_search[0][:begintime]+(50*60)).strftime("%H:%M:%S")
						if @worksenses_search[0][:endtime]==nil
							stage4time=''
						else
							stage4time=@worksenses_search[0][:endtime].strftime("%H:%M:%S")
						end
						disinfectionid=@worksenses_search[0].site[:sname]
					else
						stage3time=''
						stage4time=''
						disinfectionid=''
					end


					#如果有設定要找的洗滌機的名稱，那麼搜尋到這筆資料的洗滌機不等同於要找的洗滌機id的話，就記錄下來這筆資料等下要去掉
					if params[:disinfectionid_text]!="" and disinfectionid!=params[:disinfectionid_text] and params[:disinfectionid_text]!=nil
						@not_id+=(result.id.to_s()+',')
					else


						#計算到檢查室的時間
						stage1time=result.begintime.strftime("%H:%M:%S")
						if result.endtime==nil
							stage1endtime=''
						else
							stage1endtime=result.endtime.strftime("%H:%M:%S")
						end


						#計算到洗淨室(洗滌台)的時間
						@worksenses_search=Worksense.all.joins(:site)
						@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
						@worksenses_search=@worksenses_search.where("sites.sname like '洗滌台%'")
						@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
						@worksenses_search=@worksenses_search.order('begintime desc')
						if @worksenses_search!=[]
							stage2time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
							washid=@worksenses_search[0].site[:sname]
						else
							stage2time=''
							washid=''
						end

						#計算總費時
						if stage1time!='' and stage4time!=''
							paytime=time_diff(Time.parse(stage4time),Time.parse(stage1time))
						else
							paytime='未知'
						end

						#計算距離上次使用的存放時間
						@worksenses_search=Worksense.all.joins(:site)
						@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id} and (begindate+begintime)<'#{result.begindate} #{result.begintime.strftime("%T")}'")
						@worksenses_search=@worksenses_search.where("wid is not null and wid!='NO'")
						@worksenses_search=@worksenses_search.order('begindate desc, begintime desc')
						@worksenses_search=@worksenses_search.limit(1)
						if @worksenses_search[0]!=nil
							if @worksenses_search[0].site.sname=~/洗滌機*./
								#如果最後一筆記錄的時間是洗滌機，那就把最後一次的時間往後延50分鐘後，再計算時間差
								savetime=time_diff(Time.parse("#{@worksenses_search[0].begindate} #{@worksenses_search[0].begintime.strftime('%T')}")+50.minute,Time.parse("#{result.begindate} #{result.begintime.strftime('%T')}"))
							else
								#如果最後一筆記錄的時間是其它的時間，就直接計算時間差
								savetime=time_diff(Time.parse("#{@worksenses_search[0].begindate} #{@worksenses_search[0].begintime.strftime('%T')}"),Time.parse("#{result.begindate} #{result.begintime.strftime('%T')}"))
							end
						else
							savetime=''
						end


						#整合班表，找出清洗室的工作人員
						@schedules_search=Schedule.all
						if washid!=nil and washid!='洗滌台'
							@schedules_search=@schedules_search.where("site like '#{washid}'")
						else
							@schedules_search=@schedules_search.where("site like '洗滌台%'")
						end
						@schedules_search=@schedules_search.where("workdate='#{result.begindate}'")
						@schedules_search=@schedules_search.order('workdate desc')
						if stage2time>='14:00:00'
							@schedules_search=@schedules_search.where("workpart='下午'")
						elsif stage2time==''
							@schedules_search=@schedules_search.limit(0)
						else
							@schedules_search=@schedules_search.where("workpart='上午'")
						end
						if @schedules_search[0]!=nil
							washrole=@schedules_search[0].uid
							@schedules_search.each_with_index(){|data,i|
								washrole+=(','+data.uid)	if(i!=0)
							}
						else
							washrole=''
						end

						#整合班表，找出消毒室的工作人員
						@schedules_search=Schedule.all
						@schedules_search=@schedules_search.where("site like '洗滌機%'")
						@schedules_search=@schedules_search.where("workdate='#{result.begindate}'")
						@schedules_search=@schedules_search.order('workdate desc')
						if stage3time>='14:00:00'
							@schedules_search=@schedules_search.where("workpart='下午'")
						elsif stage3time==''
							@schedules_search=@schedules_search.limit(0)
						else
							@schedules_search=@schedules_search.where("workpart='上午'")
						end
						if @schedules_search[0]!=nil
							disinfectionrole=@schedules_search[0].uid 
						else
							disinfectionrole=''
						end


						#組合顯示用的hash
						@stage[result.id]={
							:savetime=>savetime,
							:examrole=>examrole,
							:washrole=>washrole,
							:disinfectionrole=>disinfectionrole,
							:washid=>washid,
							:disinfectionid=>disinfectionid,
							:stage1time=>stage1time, 
							:stage1endtime=>stage1endtime, 
							:stage2time=>stage2time, 
							:stage3time=>stage3time, 
							:stage4time=>stage4time, 
							:paytime=>paytime
						}
					end
				end
			}


			#如果有要排除的id，那麼就在這裡排除掉
			#if @not_id!=''
			#	@not_id=not_id[0..(@not_id.length-2)]
			#	@results_where=@results_where.where("worksenses.id not in (#{@not_id})")
			#end



			#write result to file. @xieyinghua
			withreport_writeexcel
		else
			#依客戶要求填入預設的日期為當日日期
			params[:begindate_text]=Date.today.strftime("%Y-%m-%d")
			params[:enddate_text]=Date.today.strftime("%Y-%m-%d")
		end
	end
	def showwithreport
		@examine=Examine.find_by_id(params[:id])
	end




	#write excel. @xieyinghua
  	def storetime72_writeexcel() 
	    # Create a new Excel Worksense
	    if Rails.env.production?
	      @wlink='../storetime72.xls'
	      @rlink='../storetime72.xls'
	    else
	      @wlink='public/storetime72.xls'
	      @rlink='../storetime72.xls'
	    end
	    worksense = WriteExcel.new(@wlink)


	    # Add worksheet(s)
	    worksheet  = worksense.add_worksheet

	    # Add and define a format
	    format = worksense.add_format
	    format.set_bold
	    format.set_align('center')
	    format.set_text_warp(true)


	    # write title
	    worksheet.write(0, 0, t(:sortid, :scope=>[:activerecord,:attributes,:scopy]),format)
	    worksheet.write(0, 1, t(:sid, :scope=>[:activerecord,:attributes,:scopy]),format)
	    worksheet.write(0, 2, t(:sname, :scope=>[:activerecord,:attributes,:scopy]),format)
	    

	    #write body
	    @results_where.each_with_index do |result,i|
	    	row=i+1

	    	worksheet.write(row, 0, row)
	    	worksheet.write(row, 1, result[1][:sid])
	        worksheet.write(row, 2, result[1][:sname])
	    end


	    # write to file
	    worksense.close
  	end
	def storetime72

		@results_where=Hash.new

		if params[:search]=='yes'
			#init. @xieyinghua
			d_3=(Date.today-3).strftime("%Y/%m/%d")
			t_now=Time.now.strftime("%H:%M:%S")

			#檢查每隻內視鏡三天內有無使用的記錄，沒有的話就記錄下來顯示並出報表. @xieyinghua
			@ot=0
			@scopies=Scopy.all
			@scopies=@scopies.where("status!='維修中' and status!='已停用'")
			@scopies=@scopies.order('sid asc')
			@scopies.each(){ |scopie|
				@rfbarcodes=RfBarcode.all
				@rfbarcodes=@rfbarcodes.where("rid='#{scopie.rid}'")
				@rfbarcodes=@rfbarcodes.where("scandate+scantime>'#{d_3} #{t_now}'")
				@rfbarcodes=@rfbarcodes.limit(1)

				if @rfbarcodes.count==0
					@results_where[@ot]={
						:sid=>scopie.sid,
						:sname=>scopie.sname
					}
					@ot+=1
				end
			}

			

			#write result to file. @xieyinghua
			storetime72_writeexcel()
		end
	end




	#write excel. @xieyinghua
  	def storetime168_writeexcel() 
	    # Create a new Excel Worksense
	    if Rails.env.production?
	      @wlink='../storetime168.xls'
	      @rlink='../storetime168.xls'
	    else
	      @wlink='public/storetime168.xls'
	      @rlink='../storetime168.xls'
	    end
	    worksense = WriteExcel.new(@wlink)


	    # Add worksheet(s)
	    worksheet  = worksense.add_worksheet

	    # Add and define a format
	    format = worksense.add_format
	    format.set_bold
	    format.set_align('center')
	    format.set_text_warp(true)


	    # write title
	    worksheet.write(0, 0, t(:sortid, :scope=>[:activerecord,:attributes,:scopy]),format)
	    worksheet.write(0, 1, t(:sid, :scope=>[:activerecord,:attributes,:scopy]),format)
	    worksheet.write(0, 2, t(:sname, :scope=>[:activerecord,:attributes,:scopy]),format)
	    

	    #write body
	    @results_where.each_with_index do |result,i|
	    	row=i+1

	    	worksheet.write(row, 0, row)
	    	worksheet.write(row, 1, result[1][:sid])
	        worksheet.write(row, 2, result[1][:sname])
	    end


	    # write to file
	    worksense.close
  	end
	def storetime168

		@results_where=Hash.new

		if params[:search]=='yes'
			#init. @xieyinghua
			d_7=(Date.today-7).strftime("%Y/%m/%d")
			t_now=Time.now.strftime("%H:%M:%S")

			#檢查每隻內視鏡七天內有無使用的記錄，沒有的話就記錄下來顯示並出報表. @xieyinghua
			@ot=0
			@scopies=Scopy.all
			@scopies=@scopies.where("status!='維修中' and status!='已停用'")
			@scopies=@scopies.order('sid asc')
			@scopies.each(){ |scopie|
				@rfbarcodes=RfBarcode.all
				@rfbarcodes=@rfbarcodes.where("rid='#{scopie.rid}'")
				@rfbarcodes=@rfbarcodes.where("scandate+scantime>'#{d_3} #{t_now}'")
				@rfbarcodes=@rfbarcodes.limit(1)

				if @rfbarcodes.count==0
					@results_where[@ot]={
						:sid=>scopie.sid,
						:sname=>scopie.sname
					}
					@ot+=1
				end
			}

			

			#write result to file. @xieyinghua
			storetime168_writeexcel()
		end
	end



	#write excel. @xieyinghua
  	def storetime_writeexcel() 
	    # Create a new Excel Worksense
	    if Rails.env.production?
	      @wlink='../storetime.xls'
	      @rlink='../storetime.xls'
	    else
	      @wlink='public/storetime.xls'
	      @rlink='../storetime.xls'
	    end
	    worksense = WriteExcel.new(@wlink)


	    # Add worksheet(s)
	    worksheet  = worksense.add_worksheet

	    # Add and define a format
	    format = worksense.add_format
	    format.set_bold
	    format.set_align('center')
	    format.set_text_warp(true)

	    format_red = worksense.add_format
	    format_red.set_color('red')

	    format_blue = worksense.add_format
	    format_blue.set_color('blue')


	    # write title
	    worksheet.write(0, 0, t(:sortid, :scope=>[:activerecord,:attributes,:scopy]),format)
	    worksheet.write(0, 1, t(:sid, :scope=>[:activerecord,:attributes,:scopy]),format)
	    worksheet.write(0, 2, t(:sname, :scope=>[:activerecord,:attributes,:scopy]),format)
	    worksheet.write(0, 3, t(:tag, :scope=>[:activerecord,:attributes,:scopy]),format)
	    

	    #write body
	    @results_where.each_with_index do |result,i|
	    	row=i+1

	    	if result[1][:tag]=='七天未使用'
		    	worksheet.write(row, 0, row, format_red)
		    	worksheet.write(row, 1, result[1][:sid], format_red)
		        worksheet.write(row, 2, result[1][:sname], format_red)
		        worksheet.write(row, 3, result[1][:tag], format_red)
	    	elsif result[1][:tag]=='三天未使用'
	    		worksheet.write(row, 0, row, format_blue)
		    	worksheet.write(row, 1, result[1][:sid], format_blue)
		        worksheet.write(row, 2, result[1][:sname], format_blue)
		        worksheet.write(row, 3, result[1][:tag], format_blue)
	    	end
	    end


	    # write to file
	    worksense.close
  	end
	def storetime

		@results_where=Hash.new

		if params[:search]=='yes'
			#init. @xieyinghua
			d_3=(Date.today-3).strftime("%Y/%m/%d")
			d_7=(Date.today-7).strftime("%Y/%m/%d")
			t_now=Time.now.strftime("%H:%M:%S")

			#檢查每隻內視鏡三天內有無使用的記錄，沒有的話就再確認七天內有無使用的記錄，以分類出有用、三天沒用、七天沒用的狀況並出報表. @xieyinghua
			@ot=0
			@scopies=Scopy.all
			@scopies=@scopies.where("status!='維修中' and status!='已停用'")
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

					#檢查七天內有沒用. @xieyinghua
					if @rfbarcodes7.count==0
						@results_where[@ot]={
							:sid=>scopie.sid,
							:sname=>scopie.sname,
							:tag=>'七天未使用'
						}
					else
						@results_where[@ot]={
							:sid=>scopie.sid,
							:sname=>scopie.sname,
							:tag=>'三天未使用'
						}
					end
					@ot+=1
				end
			}

			

			#write result to file. @xieyinghua
			storetime_writeexcel()
		end
	end





	private
	    # Never trust parameters from the scary internet, only allow the white list through.
	    def site_params
	      	params.require(:site).permit(:sname)
	    end
	    def examine_params
	      	params.require(:examine).permit(:seq, :e_seq, :typeid, :type_name, :source, :stat, :stat_Name, :charg_date, :charg_time, :login_date, :login_time, :orderdr, :orderdrname, :studydr, :studydrname, :enterdr, :enterdrname, :Comple_Date, :comple_time, :enter_date, :enter_time, :report, :pacsno)
	    end
	    def worksense_params
	      	params.require(:worksense).permit(:user_id, :scopy_id, :patient_id, :examine_id, :site_id, :begindate, :begintime, :enddate, :endtime)
	    end
	    def scopy_params
			params.require(:scopy).permit(:rid, :pid, :cid, :mid, :sid, :slabel, :sname, :sclass, :status)
		end
		def patient_params
	      	params.require(:patient).permit(:chart, :pname, :birthday, :sex, :telephone, :address)
	    end
	    def user_params
	      	params.require(:user).permit(:uid, :upw, :uname, :utitle)
	    end
end
