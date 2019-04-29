class QueryEndoController < ApplicationController
	layout 'full', only: [:fullsite]


	def byaccessionno
		@worksenses=Worksense.all


		#query. @xieyinghua
		@worksenses_where=@worksenses.joins(:examine)	#inner join examine table. @xieyinghua
		@worksenses_where=@worksenses_where.where('examines.seq'=>params[:seq_text]) if params[:seq_text]!=""
		#@worksenses_where=@worksenses_where.where(:begindate=>params[:begindate_text]) if params[:begindate_text]!=""
		#@worksenses_where=@worksenses_where.where(:enddate=>params[:enddate_text]) if params[:enddate_text]!=""
		@worksenses_where=@worksenses_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
		@worksenses_where=@worksenses_where.where("enddate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil

		
		#write result to file. @xieyinghua
=begin
		erb_str = File.read('app/views/query_endo/_formbyaccessionno.html.erb')
		renderer = ERB.new(erb_str)
		result = renderer.result(binding)	#binding to setting variant to render. @xieyinghua
		f=File.new("public/List.csv", "w:utf-8")
      	f.write(result)
      	f.close()
=end
	end
	def bysid
		@worksenses=Worksense.all


		#query. @xieyinghua
		@worksenses_where=@worksenses.joins(:scopy)	#inner join scopy table. @xieyinghua
		@worksenses_where=@worksenses_where.where('scopies.sid'=>params[:sid_text]) if params[:sid_text]!=""
		#@worksenses_where=@worksenses_where.where(:begindate=>params[:begindate_text]) if params[:begindate_text]!=""
		#@worksenses_where=@worksenses_where.where(:enddate=>params[:enddate_text]) if params[:enddate_text]!=""
		@worksenses_where=@worksenses_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
		@worksenses_where=@worksenses_where.where("enddate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil

		
		#write result to file. @xieyinghua
=begin
		erb_str = File.read('app/views/query_endo/_formbysid.html.erb')
		renderer = ERB.new(erb_str)
		result = renderer.result(binding)	#binding to setting variant to render. @xieyinghua
		f=File.new("public/List.csv", "w:utf-8")
      	f.write(result)
      	f.close()
=end
	end
	def bydatetime
		@worksenses=Worksense.all


		#query. @xieyinghua
		@worksenses_where=@worksenses	#no any inner join table. @xieyinghua
		#if params[:endtime_text]!=nil && params[:begintime_text]!=nil
		#	begintime_variant="#{params[:begintime_text]['(4i)']}:#{params[:begintime_text]['(5i)']}:00"
		#	endtime_variant="#{params[:endtime_text]['(4i)']}:#{params[:endtime_text]['(5i)']}:59"
		#	@worksenses_where=@worksenses_where.where("strftime('%H:%M:%S',begintime)>='#{begintime_variant}' and strftime('%H:%M:%S',endtime)<='#{endtime_variant}'")	
		#end
		if params[:begintime_text]!=nil
			begintime_variant="#{params[:begintime_text]['(4i)']}:#{params[:begintime_text]['(5i)']}:00"
			@worksenses_where=@worksenses_where.where("strftime('%H:%M:%S',begintime)>='#{begintime_variant}'")	
		end
		if params[:endtime_text]!=nil
			endtime_variant="#{params[:endtime_text]['(4i)']}:#{params[:endtime_text]['(5i)']}:59"
			@worksenses_where=@worksenses_where.where("strftime('%H:%M:%S',endtime)<='#{endtime_variant}'")	
		end
		#@worksenses_where=@worksenses_where.where(:begindate=>params[:begindate_text]) if params[:begindate_text]!=""
		#@worksenses_where=@worksenses_where.where(:enddate=>params[:enddate_text]) if params[:enddate_text]!=""
		@worksenses_where=@worksenses_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
		@worksenses_where=@worksenses_where.where("enddate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil

		
		#write result to file. @xieyinghua
=begin
		erb_str = File.read('app/views/query_endo/_formbydatetime.html.erb')
		renderer = ERB.new(erb_str)
		result = renderer.result(binding)	#binding to setting variant to render. @xieyinghua
		f=File.new("public/List.csv", "w:utf-8")
      	f.write(result)
      	f.close()
=end
	end
	def byrid
		@worksenses=Worksense.all


		#query. @xieyinghua
		@worksenses_where=@worksenses.joins(:scopy)	#inner join scopy table. @xieyinghua
		@worksenses_where=@worksenses_where.where('scopies.rid'=>params[:rid_text]) if params[:rid_text]!=""
		#@worksenses_where=@worksenses_where.where(:begindate=>params[:begindate_text]) if params[:begindate_text]!=""
		#@worksenses_where=@worksenses_where.where(:enddate=>params[:enddate_text]) if params[:enddate_text]!=""
		@worksenses_where=@worksenses_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
		@worksenses_where=@worksenses_where.where("enddate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil

		
		#write result to file. @xieyinghua
=begin
		erb_str = File.read('app/views/query_endo/_formbyrid.html.erb')
		renderer = ERB.new(erb_str)
		result = renderer.result(binding)	#binding to setting variant to render. @xieyinghua
		f=File.new("public/List.csv", "w:utf-8")
      	f.write(result)
      	f.close()
=end
	end




	def rebuild
		@results_where=Hash.new

		if params[:search]=='yes'
			#query. @xieyinghua
			@results_where=Worksense.all
			@results_where=@results_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@results_where=@results_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			
			@results_where.each(){ |result|
				result.destroy
			}

			@msg='已開始重建，請靜候五分鐘再重開系統'
		else
			#依客戶要求填入預設的日期為當日日期
			params[:begindate_text]=Date.today.strftime("%Y-%m-%d")
			params[:enddate_text]=Date.today.strftime("%Y-%m-%d")
		end

	end



	#write excel. @xieyinghua
  	def errorlist_writeexcel() 
	    # Create a new Excel Worksense
	    if Rails.env.production?
	      @wlink='../errorlist.xls'
	      @rlink='../errorlist.xls'
	    else
	      @wlink='public/errorlist.xls'
	      @rlink='../errorlist.xls'
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
	    worksheet.write(0, 1, t(:wid, :scope=>[:activerecord,:attributes,:wk_barcode]),format)
        worksheet.write(0, 2, t(:rid, :scope=>[:activerecord,:attributes,:scopy]),format)
        worksheet.write(0, 3, t(:sid, :scope=>[:activerecord,:attributes,:scopy]),format)
        worksheet.write(0, 4, t(:stagedate, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 5, t(:siteid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 6, t(:stage1time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 7, t(:stage1endtime, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 8, t(:washid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 9, t(:stage2time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 10, t(:disinfectionid, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 11, t(:stage3time, :scope=>[:activerecord,:attributes,:worksense]),format)
        worksheet.write(0, 12, t(:stage4time, :scope=>[:activerecord,:attributes,:worksense]),format)
	    

	    #write body
	    row=0
	    @results_where.each_with_index do |result,i|
	    	if !(@not_id.include? result.id.to_s())
		    	row=row+1

		    	worksheet.write(row, 0, row)
		    	worksheet.write(row, 1, result.wid)
		    	if result.scopy==nil
			        worksheet.write(row, 2, '')
			        worksheet.write(row, 3, '')
			    else
			    	worksheet.write(row, 2, result.scopy.rid)
			        worksheet.write(row, 3, result.scopy.sid)
			    end
		        worksheet.write(row, 4, result.begindate)
		        worksheet.write(row, 5, result.site.sname )
		        if @stage[result.id][:stage1time]==nil
		        	worksheet.write(row, 6, '')
		        else
			        worksheet.write(row, 6, @stage[result.id][:stage1time])
			    end
			    if @stage[result.id][:stage1endtime]==nil
		        	worksheet.write(row, 7, '')
		        else
		        	worksheet.write(row, 7, @stage[result.id][:stage1endtime])
		        end
		        if @stage[result.id][:stage2site]==nil
		        	worksheet.write(row, 8, '')
		        else
		        	worksheet.write(row, 8, @stage[result.id][:stage2site])
		        end
		        if @stage[result.id][:stage2time]==nil
		        	worksheet.write(row, 9, '')
		        else
		        	worksheet.write(row, 9, @stage[result.id][:stage2time])
		        end
		        if @stage[result.id][:stage3site]==nil
		        	worksheet.write(row, 10, '')
		        else
		        	worksheet.write(row, 10, @stage[result.id][:stage3site])
		        end
		        if @stage[result.id][:stage3time]==nil
		        	worksheet.write(row, 11, '')
		        else
		        	worksheet.write(row, 11, @stage[result.id][:stage3time])
		        end
		        if @stage[result.id][:stage4time]==nil
		        	worksheet.write(row, 12, '')
		        else
		        	worksheet.write(row, 12, @stage[result.id][:stage4time])
		        end
		    end
	    end


	    # write to file
	    worksense.close
  	end
	def errorlist
		@results_where=Hash.new

		if params[:search]=='yes'
			#query. @xieyinghua
			#原本正常一組頭對一組尾的狀況
			#@results_where=Worksense.all.joins(:scopy).joins(:site).joins(:patient) 
			#因為會有多刷的情況，又有引用到病人，造成可能會出現多組頭對到單組後面資料的狀況，所以用left join全抓，讓使用者自已判紹要怎麼補資料。而processtime及withreport以資料正確性為目標，絕對不加用left join，不然會出現多餘的資料筆數
			@results_where=Worksense.all.joins('left join scopies on worksenses.scopy_id=scopies.id').joins('left join sites on worksenses.site_id=sites.id').joins('left join patients on worksenses.patient_id=patients.id')
			@results_where=@results_where.select('DISTINCT ON (begindate,patient_id,site_id,scopy_id,wid) worksenses.*,scopies.sname,patients.pid,patients.pname,sites.sname')
			@results_where=@results_where.where("sites.sname in ('Room1','Room2','Room3','Room4','Room5','ERCP','外做')")
			#疑似會造成bug，有NO的一般是找不到資料的
			#@results_where=@results_where.where("wid is not null and wid!='NO' and worksenses.scopy_id is not null and worksenses.site_id is not null and worksenses.patient_id is not null")
			#理論上應該用這個
			@results_where=@results_where.where("wid is not null")
			@results_where=@results_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@results_where=@results_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@results_where=@results_where.order('begindate asc')

			@not_id=''
			@stage=Hash.new
			@results_where.each(){ |result|


				#計算到消毒室(洗滌機)的時間，並取得機號的編號
				if result.scopy_id!=nil
					@worksenses_search=Worksense.all.joins(:site)
					@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
					@worksenses_search=@worksenses_search.where("sites.sname like '洗滌機%'")
					@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
					@worksenses_search=@worksenses_search.order('begintime desc')
					if @worksenses_search!=[]
						stage3site=@worksenses_search[0][:site_id]
						stage3time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
						#stage4time=(@worksenses_search[0][:begintime]+(50*60)).strftime("%H:%M:%S")
						if @worksenses_search[0][:endtime]==nil
							stage4time=''
						else
							stage4time=@worksenses_search[0][:endtime].strftime("%H:%M:%S")
						end
					else
						stage3time=''
						stage4time=''
					end
				else
					stage3time=''
					stage4time=''
				end



				#計算到檢查室的時間
				stage1time=result.begintime.strftime("%H:%M:%S")
				if result.endtime==nil
					stage1endtime=''
				else
					stage1endtime=result.endtime.strftime("%H:%M:%S")
				end
				

				#計算到洗靜室(洗滌台)的時間
				if result.scopy_id!=nil
					@worksenses_search=Worksense.all.joins(:site)
					@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
					@worksenses_search=@worksenses_search.where("sites.sname like '洗滌台%'")
					@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
					@worksenses_search=@worksenses_search.order('begintime desc')
					if @worksenses_search!=[]
						stage2site=@worksenses_search[0][:site_id]
						stage2time=@worksenses_search[0][:begintime].strftime("%H:%M:%S")
					else
						stage2time=''
					end
				else
					stage2time=''
				end
				


				#組合顯示用的hash，如果都沒有缺資料，那就不必顯示了
				if stage1time=='' || stage1endtime=='' || stage2time=='' || stage3time=='' || stage4time==''
					@stage[result.id]={
						:stage1time=>stage1time, 
						:stage1endtime=>stage1endtime, 
						:stage2time=>stage2time, 
						:stage3time=>stage3time, 
						:stage4time=>stage4time,
						:stage2site=>stage2site,
						:stage3site=>stage3site
					}
				else
					@not_id+=(result.id.to_s()+',')
				end
			}


			#如果有要排除的id，那麼就在這裡排除掉
			#if @not_id!=''
			#	@not_id=@not_id[0..(@not_id.length-2)]
			#	@results_where=@results_where.where("worksenses.id not in (#{@not_id})")
			#end
			

			#write result to file. @xieyinghua
			errorlist_writeexcel()
		else
			#依客戶要求填入預設的日期為當日日期
			params[:begindate_text]=Date.today.strftime("%Y-%m-%d")
			params[:enddate_text]=Date.today.strftime("%Y-%m-%d")
		end
	end



	# GET /companies
  	# GET /companies.json
  	def showerrorlist
  		idx=0
	    loop do
	    	#p params
	    	id=params[:"id_#{idx}"]
	    	if id!=nil
		    	@worksenses_where=Worksense.find(id)
		    	begindate=@worksenses_where.begindate
		    	endtime=@worksenses_where.endtime
		    	scopy_id=@worksenses_where.scopy_id
		    	patient_id=@worksenses_where.patient_id
		    	examine_id=@worksenses_where.examine_id
		    	wid=@worksenses_where.wid
		    	stage1time=params[:"stage1time_#{idx}"]

		    	
	    		
	    		stage1endtime=params[:"stage1endtime_#{idx}"]
	    		if stage1endtime!=nil and stage1time!=''
					@result_where=Worksense.all.where("wid='#{wid}' and begindate='#{begindate}' and begintime='#{stage1time}'")
	    			if @result_where.count==1
	    				wk=Worksense.find(@result_where[0][:id])
	    				wk.enddate=begindate
	    				wk.endtime=stage1endtime
	    				wk.save
	    			end
	    		end


	    		stage2time=params[:"stage2time_#{idx}"]
	    		stage2site=params[:"stage2site_#{idx}"]
	    		if stage2time!=nil and stage2time!='' and stage2site!=nil and stage2site!=''
	    			@result_where=Worksense.all.where("wid='#{wid}' and begindate='#{begindate}' and begintime='#{stage2time}'")
	    			if @result_where.count==0
		    			wk=Worksense.new
		    			wk[:begindate]=begindate
		    			wk[:begintime]=stage2time
		    			wk[:scopy_id]=scopy_id
		    			wk[:patient_id]=patient_id
		    			wk[:examine_id]=examine_id
		    			wk[:site_id]=stage2site
		    			wk[:wid]=wid
		    			wk.save
		    		end
	    		end


	    		stage3time=params[:"stage3time_#{idx}"]
	    		stage3site=params[:"stage3site_#{idx}"]
	    		if stage3time!=nil and stage3time!='' and stage3site!=nil and stage3site!=''
	    			@result_where=Worksense.all.where("wid='#{wid}' and begindate='#{begindate}' and begintime='#{stage3time}'")
	    			if @result_where.count==0
		    			wk=Worksense.new
		    			wk[:begindate]=begindate
		    			wk[:begintime]=stage3time
		    			wk[:scopy_id]=scopy_id
		    			wk[:patient_id]=patient_id
		    			wk[:examine_id]=examine_id
		    			wk[:site_id]=stage3site
		    			wk[:wid]=wid
		    			wk.save
		    		end
	    		end

	    		stage4time=params[:"stage4time_#{idx}"]
	    		if stage4time!=nil and stage4time!=''
	    			@result_where=Worksense.all.where("wid='#{wid}' and begindate='#{begindate}' and begintime='#{stage3time}'")
	    			if @result_where.count==1
	    				wk=Worksense.find(@result_where[0][:id])
	    				wk.enddate=begindate
	    				wk.endtime=stage4time
	    				wk.save
	    			end
	    		end

	    		idx+=1
	    	else
	    		break
	    	end
	    end

	    #attn=params[:attn]
	    #d=Time.now.strftime("%d-%b-%Y")

	    #@companies = Company.all
	    #company=@companies.where("id='#{idx}'").first
	  end





	def errordata
		@wks_where=Hash.new
		@stages_where=Hash.new
		@tables_where=Hash.new
		@machines_where=Hash.new


		if params[:search]=='yes'
			#取出所有指定日期的工單掃碼資料
			@wks_where=WkBarcode.all
			@wks_where=@wks_where.select('wk_barcodes.*')
			@wks_where=@wks_where.where("scandate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@wks_where=@wks_where.where("scandate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@wks_where=@wks_where.order('scandate desc, scantime desc')



			#取出所有還沒有配對的檢查作業. @xieyinghua
			#原本正常一組頭對一組尾的狀況
			#@results_where=Worksense.all.joins(:scopy).joins(:site).joins(:patient) 
			#因為會有多刷的情況，又有引用到病人，造成可能會出現多組頭對到單組後面資料的狀況，所以用left join全抓，讓使用者自已判紹要怎麼補資料。而processtime及withreport以資料正確性為目標，絕對不加用left join，不然會出現多餘的資料筆數
			#@results_where=Worksense.all.joins('left join scopies on worksenses.scopy_id=scopies.id').joins('left join sites on worksenses.site_id=sites.id').joins('left join patients on worksenses.patient_id=patients.id')
			#僅為病人可能空白予以容忍，其它不允許空白
			@stages_where=Worksense.all.joins(:scopy).joins(:site).joins('left join patients on worksenses.patient_id=patients.id')
			@stages_where=@stages_where.select('worksenses.*,scopies.sname,patients.pid,patients.pname,sites.sname')
			@stages_where=@stages_where.where("sites.sname in ('Room1','Room2','Room3','Room4','Room5','ERCP','外做')")
			@stages_where=@stages_where.where("wid='NO' and worksenses.scopy_id is not null and worksenses.site_id is not null")
			@stages_where=@stages_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@stages_where=@stages_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@stages_where=@stages_where.order('begindate asc')



			#取出所有還沒有配對的洗淨台
			@tables_where=Worksense.all.joins(:scopy).joins(:site).joins('left join patients on worksenses.patient_id=patients.id')
			@tables_where=@tables_where.select('worksenses.*,scopies.sname,patients.pid,patients.pname,sites.sname')
			@tables_where=@tables_where.where("sites.sname like '洗滌台%'")
			@tables_where=@tables_where.where("wid='NO' and worksenses.scopy_id is not null and worksenses.site_id is not null")
			@tables_where=@tables_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@tables_where=@tables_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@tables_where=@tables_where.order('begindate asc')



			#取出所有還沒有配對的洗淨機
			@machines_where=Worksense.all.joins(:scopy).joins(:site).joins('left join patients on worksenses.patient_id=patients.id')
			@machines_where=@machines_where.select('worksenses.*,scopies.sname,patients.pid,patients.pname,sites.sname')
			@machines_where=@machines_where.where("sites.sname like '洗滌機%'")
			@machines_where=@machines_where.where("wid='NO' and worksenses.scopy_id is not null and worksenses.site_id is not null")
			@machines_where=@machines_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@machines_where=@machines_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@machines_where=@machines_where.order('begindate asc')


		else
			#依客戶要求填入預設的日期為當日日期
			params[:begindate_text]=Date.today.strftime("%Y-%m-%d")
			params[:enddate_text]=Date.today.strftime("%Y-%m-%d")
		end
	end



	def mergedata
		@wkb_where=Hash.new
		@wks_where=Hash.new


		if params[:search]=='yes'


			if params[:stage]=='0'
				#取出所有還沒有配對的檢查作業. @xieyinghua
				#原本正常一組頭對一組尾的狀況
				#@results_where=Worksense.all.joins(:scopy).joins(:site).joins(:patient) 
				#因為會有多刷的情況，又有引用到病人，造成可能會出現多組頭對到單組後面資料的狀況，所以用left join全抓，讓使用者自已判紹要怎麼補資料。而processtime及withreport以資料正確性為目標，絕對不加用left join，不然會出現多餘的資料筆數
				#@results_where=Worksense.all.joins('left join scopies on worksenses.scopy_id=scopies.id').joins('left join sites on worksenses.site_id=sites.id').joins('left join patients on worksenses.patient_id=patients.id')
				#僅為病人可能空白予以容忍，其它不允許空白
				@wks_where=Worksense.all.joins(:scopy).joins(:site).joins('left join patients on worksenses.patient_id=patients.id')
				@wks_where=@wks_where.select('worksenses.*,scopies.sname,patients.pid,patients.pname,sites.sname')
				@wks_where=@wks_where.where("(sites.sname in ('Room1','Room2','Room3','Room4','Room5','ERCP','外做') or sites.sname like '洗滌台%' or sites.sname like '洗滌機%')")
				@wks_where=@wks_where.where("wid='NO' and worksenses.scopy_id is not null and worksenses.site_id is not null")
				@wks_where=@wks_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
				@wks_where=@wks_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
				@wks_where=@wks_where.order('begindate asc')

				if @wks_where==[]
					@stage='0'
				else
					@stage='1'
				end


			elsif params[:stage]=='1'
				#取出所有指定日期的工單掃碼資料
				@wkb_where=WkBarcode.all
				@wkb_where=@wkb_where.select('wk_barcodes.*')
				@wkb_where=@wkb_where.where("scandate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
				@wkb_where=@wkb_where.where("scandate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
				@wkb_where=@wkb_where.order('scandate desc, scantime desc')

				@stage='2'


			elsif params[:stage]=='2'
				#st = ActiveRecord::Base.connection.raw_connection.prepare("update worksenses set wid=? where id=?")
				#st.execute(params[:selectwid], params[:selectsid])
				#st.close

				sql="update worksenses set wid='#{params[:selectwid]}' where id=#{params[:selectsid]}"
				ActiveRecord::Base.connection.execute(sql)

				@stage='0'


			end
		else
			#依客戶要求填入預設的日期為當日日期
			params[:begindate_text]=Date.today.strftime("%Y-%m-%d")
			params[:enddate_text]=Date.today.strftime("%Y-%m-%d")
		end
	end





	def mergeprocesstime
		
		@results_where=Hash.new

		if params[:search]=='yes'
			#query. @xieyinghua
			@results_where=Worksense.all.joins(:scopy).joins(:site)
			@results_where=@results_where.select('worksenses.*,scopies.sname,sites.sname')
			@results_where=@results_where.where("(sites.sname in ('Room1','Room2','Room3','Room4','Room5','ERCP','外做') or sites.sname like '洗滌台%' or sites.sname like '洗滌機%')")
			@results_where=@results_where.where("wid is not null")
			@results_where=@results_where.where("begindate>='#{params[:begindate_text]}'") if params[:begindate_text]!="" and params[:begindate_text]!=nil
			@results_where=@results_where.where("begindate<='#{params[:enddate_text]}'") if params[:enddate_text]!="" and params[:enddate_text]!=nil
			@results_where=@results_where.order('begindate asc')
			
			@not_id=''
			@stage=Hash.new
			@results_where.each(){ |result|



				
				if result.site.sname=='Room1' || result.site.sname=='Room2' || result.site.sname=='Room3' || result.site.sname=='Room4' || result.site.sname=='Room5' || result.site.sname=='ERCP' || result.site.sname=='外做'
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



					#計算到消毒室(洗滌機)的時間，並取得機號的編號
					@worksenses_search=Worksense.all.joins(:site)
					@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
					@worksenses_search=@worksenses_search.where("sites.sname like '洗滌機%'")
					@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
					@worksenses_search=@worksenses_search.order('begintime desc')
					if @worksenses_search!=[]
						disinfectionid=@worksenses_search[0].site[:sname]
					else
						disinfectionid=''
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
				else


				end



				if result.site.sname=='Room1' || result.site.sname=='Room2' || result.site.sname=='Room3' || result.site.sname=='Room4' || result.site.sname=='Room5' || result.site.sname=='ERCP' || result.site.sname=='外做' || result.site.sname.match(/洗淨台.*/)
					#計算到洗淨室(洗滌台)的時間
					@worksenses_search=Worksense.all.joins(:site)
					@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
					@worksenses_search=@worksenses_search.where("sites.sname like '洗滌台%'")
					@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
					@worksenses_search=@worksenses_search.order('begintime desc')
					if @worksenses_search!=[]
						washid=@worksenses_search[0].site[:sname]
					else
						washid=''
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
				end



				#計算到消毒室(洗滌機)的時間，並取得機號的編號
				@worksenses_search=Worksense.all.joins(:site)
				@worksenses_search=@worksenses_search.where("scopy_id=#{result.scopy_id}")
				@worksenses_search=@worksenses_search.where("sites.sname like '洗滌機%'")
				@worksenses_search=@worksenses_search.where("wid='#{result.wid}' and begindate='#{result.begindate}' and begintime>'#{result.begintime.strftime("%T")}'")
				@worksenses_search=@worksenses_search.order('begintime desc')
				if @worksenses_search!=[]
					disinfectionid=@worksenses_search[0].site[:sname]
				else
					disinfectionid=''
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
					:examrole=>examrole,
					:washrole=>washrole,
					:washid=>washid,
					:disinfectionrole=>disinfectionrole,
					:disinfectionid=>disinfectionid
				}


			}






			#如果有要排除的id，那麼就在這裡排除掉
			#if @not_id!=''
			#	@not_id=not_id[0..(@not_id.length-2)]
			#	@results_where=@results_where.where("worksenses.id not in (#{@not_id})")
			#end
			

			#write result to file. @xieyinghua
			#processtime_writeexcel()
		else
			#依客戶要求填入預設的日期為當日日期
			params[:begindate_text]=Date.today.strftime("%Y-%m-%d")
			params[:enddate_text]=Date.today.strftime("%Y-%m-%d")
		end
	end




	def loadsite

		@scopys_where=Hash.new

		if params[:search]=='yes'		
			#query. @xieyinghua
			@scopys_where=Scopy.all
			@scopys_where=@scopys_where.where('scopies.rid'=>params[:rid_text]) if params[:rid_text]!=""
			@scopys_where=@scopys_where.where('scopies.pid'=>params[:pid_text]) if params[:pid_text]!=""
			@scopys_where=@scopys_where.where('scopies.cid'=>params[:cid_text]) if params[:cid_text]!=""
			@scopys_where=@scopys_where.where('scopies.mid'=>params[:mid_text]) if params[:mid_text]!=""
			@scopys_where=@scopys_where.where('scopies.sid'=>params[:sid_text]) if params[:sid_text]!=""
			@scopys_where=@scopys_where.where('scopies.slabel'=>params[:slabel_text]) if params[:slabel_text]!=""
			@scopys_where=@scopys_where.where('scopies.sname'=>params[:sname_text]) if params[:sname_text]!=""
			@scopys_where=@scopys_where.where('scopies.sclass'=>params[:sclass_text]) if params[:sclass_text]!=""
			#@scopys_where=@scopys_where.group('scopies.sid')

			#p @scopys_where
			if params[:status_text]=='所有待洗的內視鏡'
				@scopys_where=@scopys_where.where.not('scopies.status'=>'鏡架上').where.not('scopies.status'=>'洗滌台').where.not('scopies.status'=>'維修中').where.not("scopies.status like '洗滌機%'")
			else
				@scopys_where=@scopys_where.where('scopies.status'=>params[:status_text])
			end
		end
	end
	def site
		#get customer
		@customer=get_customer

		loadsite
	end
	def fullsite
		#get customer
		@customer=get_customer
		
		loadsite
	end



  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def worksense_params
      params.require(:worksense).permit(:user_id, :scopy_id, :patient_id, :examine_id, :begindate, :begintime, :enddate, :endtime, :site, :pid, :accessionno)
    end
end
