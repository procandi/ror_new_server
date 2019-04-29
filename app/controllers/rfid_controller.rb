class RfidController < ApplicationController
  soap_service namespace: 'urn:QCEndo'


  # You can use all Rails features like filtering, too. A SOAP controller
  # is just like a normal controller with a special routing.
  before_filter :dump_parameters
  def dump_parameters
    Rails.logger.debug params.inspect
  end


  # 構想是，RFID送上資料後，在伺服器端利用site會知道是哪一台RFID送上來的。再利用這個資料，去檢索彰基2000，找出相對應那台RFID的主機，最後一筆報到的資料。 @xieyinghua
  # add rfid record. @xieyinghua
  soap_action "add_rfid_record",
              :args   => { :rid => :string, :pid => :string, :begindate => :date, :begintime => :time, :enddate => :date, :endtime => :time, :site => :string },
              :return => :string
  def add_rfid_record

    if true 
      @rf_barcode=RfBarcode.new
      rid=params[:rid]
      site=params[:site]
      scandate=Date.today.strftime("%Y/%m/%d")
      scantime=Time.now.strftime("%H:%M:%S")


      @rf_barcode.rid=rid
      @rf_barcode.site=site
      @rf_barcode.scandate=scandate
      @rf_barcode.scantime=scantime


      p @rf_barcode
      @rf_barcode.save

      render :soap => 'ok'

    else
      #search scopy record first, do something if not nil. @xieyinghua
      if params[:rid]=='3594067956'
        rid='05708180'
      elsif params[:rid]=='3594366964'
        rid='06145044'
      elsif params[:rid]=='3593690484'
        rid='05123924'
      else
        rid=params[:rid]
      end
      query=Scopy.where(:rid=>rid).limit(1)
      if(query!=[])
        #add worksense record. @xieyinghua
        @worksense=Worksense.new
        @worksense.begindate=params[:begindate].strftime("%Y/%m/%d")
        @worksense.begintime=params[:begintime].strftime("%H:%M:%S")
        @worksense.enddate=params[:enddate].strftime("%Y/%m/%d")
        @worksense.endtime=params[:endtime].strftime("%H:%M:%S")


        #found scopy record. @xieyinghua
        scopy=query[0]
        @worksense.scopy_id=scopy.id


        #syn patient id with CCH 2000 system. @xieyinghua
        if params[:pid]!=nil
          #get patient chart number to get patient database id. @xieyinghua
          patient_query=Patient.where(:pid=>params[:pid]).limit(1)  #patient_query=Patient.where(:pid=>'123456').limit(1)
          if patient_query==[]
            #create new patient. @xieyinghua
            get_ptdata(params[:pid])

            #get new creat patient chart number. @xieyinghua
            patient_query=Patient.where(:pid=>params[:pid]).limit(1)  #patient_query=Patient.where(:pid=>'123456').limit(1)
          end
          #make a current data for save. @xieyinghua
          patient=patient_query[0]
          @worksense.patient_id=patient.id


          
          #create new examine. @xieyinghua
          seq=get_exam(params[:pid])

          #get new creat patient chart number. @xieyinghua
          examine_query=Examine.where(:seq=>seq).limit(1)
          
          #make a current data for save. @xieyinghua
          examine=examine_query[0]
          @worksense.examine_id=examine.id



          #@worksense.user_id=nil #default set a empty user. @xieyinghua
        end


        #sync site id with database. @xieyinghua
        #get site name to get site database id. @xieyinghua
        site_query=Site.where(:sname=>params[:site]).limit(1)
        if site_query!=nil
          #make a current data for save. @xieyinghua
          site=site_query[0]
          @worksense.site_id=site.id
        end


        p @worksense
        @worksense.save

        render :soap => 'ok'
      else
        #no record. @xieyinghua
        render :soap => 'fail'
      end
    end
  end



  def get_ptid(workseq)
    #load properties
    wsdl_url="http://cchwsvr.cch.org.tw/DailyHealthcare/ExamWebSrv.asmx?wsdl"

    #connect to SOAP web service
    client = Savon::Client.new(wsdl: wsdl_url)


    result = client.call(:get_exam_7 , message: { "sWorkSeq"=>workseq })
    #p result
    ret=result.to_hash[:get_exam_7_response][:get_exam_7_result]
    ret1=eval(ret)[0]
    chart=ret1[:CHART] if ret1!=nil
    #p ret1[:CHART]

    chart
  end


  def get_ptdata(chart)
    #load properties
    wsdl_url="http://cchwsvr.cch.org.tw/HIS_WS_ENDO/Ws_getPtChk.asmx?wsdl"

    #connect to SOAP web service
    client = Savon::Client.new(wsdl: wsdl_url)


    result = client.call(:get_ptdata , message: { "v_chart"=>chart })
    #p result
    ret=result.to_hash[:get_ptdata_response][:get_ptdata_result]
    ret_ptdata=eval(ret)[0]
    #p ret_ptdata[:CHART]
    #p ret_ptdata[:NAME]
    #p ret_ptdata[:SEX]
    #p ret_ptdata[:BORN_YYMMDD]
    #p ret_ptdata[:TEL]
    #p ret_ptdata[:ADDRESS]
    

    patient=Patient.new
    patient.pid=ret_ptdata[:CHART]  #test data=123456
    patient.pname=ret_ptdata[:NAME]
    if ret1[:BORN_YYMMDD]!=nil && ret_ptdata[:BORN_YYMMDD].to_s().length==6
      #Republic of China(ROC) age to West age.
      year=ret_ptdata[:BORN_YYMMDD]/10000+1911
      month=(ret_ptdata[:BORN_YYMMDD]%10000/100).to_s().rjust(2, '0')
      day=(ret_ptdata[:BORN_YYMMDD]%100).to_s().rjust(2, '0')
      patient.birthday="#{year}-#{month}-#{day}"
    end
    patient.sex=ret_ptdata[:SEX]
    patient.telephone=ret_ptdata[:TEL]
    patient.address=ret_ptdata[:ADDRESS]
    patient.save


    p "***** patient #{chart} inserted."
    chart
  end


  def get_exam(chart)
    #init array
    examine=[]


    #load properties
    wsdl_url="http://cchwsvr.cch.org.tw/DailyHealthcare/ExamWebSrv.asmx?wsdl"

    #connect to SOAP web service
    client = Savon::Client.new(wsdl: wsdl_url)


    #get exam 1
    result = client.call(:get_exam_1 , message: { "sChart"=>chart })
    #p result
    ret=result.to_hash[:get_exam_1_response][:get_exam_1_result]
    ret1=eval(ret)
    ret2=Hash[ret1.each_with_index.map{ |hash,i| [i,hash] }]
    ret_exam_1=ret2.select{|key, hash| hash[:TYPE]=="AA" || hash[:TYPE]=="CL" || hash[:TYPE]=="CM" || hash[:TYPE]=="GA" || hash[:TYPE]=="GD" || hash[:TYPE]=="GE" || hash[:TYPE]=="GM" || hash[:TYPE]=="GS" || hash[:TYPE]=="GU" }
    ret_exam_1.each_with_index(){|retin,i|
      #p retin[1][:CHART]
      #p retin[1][:TYPE]
      #p retin[1][:TYPE_NAM]


      #get exam 2
      result = client.call(:get_exam_2 , message: { "sChart"=>chart, "sType"=>retin[1][:TYPE] })
      #p result
      ret=result.to_hash[:get_exam_2_response][:get_exam_2_result]
      ret_exam_2=eval(ret)[0]
      #p ret_exam_2
      #p ret_exam_2[:SEQ]
      #p ret_exam_2[:CHART]
      #p ret_exam_2[:TYPE]
      #p ret_exam_2[:SOURC]
      #p ret_exam_2[:STAT]
      #p ret_exam_2[:CHARGS]
      #p ret_exam_2[:LOGIN_TIM]
      #p ret_exam_2[:E_SEQ]
      #p ret_exam_2[:ORDER_DR]
      #p ret_exam_2[:TYPE_NAM]
      #p ret_exam_2[:EMP_NAM]
      #p ret_exam_2[:STAT_DESC]


      #loading seq and eseq. @xieyinghua
      seq=ret_exam_2[:SEQ]
      eseq=ret_exam_2[:E_SEQ]


      #get exam 3
      result = client.call(:get_exam_3 , message: { "sChart"=>chart, "sE_Seq"=>eseq, "sSeq"=>seq })
      #p result
      ret=result.to_hash[:get_exam_3_response][:get_exam_3_result]
      ret_exam_3=eval(ret)[0]
      #p ret_exam_3
      #p ret_exam_3[:CHART]
      #p ret_exam_3[:SOURCE]
      #p ret_exam_3[:TYPE]
      #p ret_exam_3[:TYPE_NAM]
      #p ret_exam_3[:STAT]
      #p ret_exam_3[:STATNAME]
      #p ret_exam_3[:ORDERDR]
      #p ret_exam_3[:ORDERDRNAME]
      #p ret_exam_3[:ORDERTIME]
      #p ret_exam_3[:LOGINTIME]
      #p ret_exam_3[:SEQ]
      #p ret_exam_3[:E_SEQ]
      #p ret_exam_3[:STUDYDR]
      #p ret_exam_3[:STUDYDRNAME]
      #p ret_exam_3[:ENTERDR]
      #p ret_exam_3[:ENTERDRNAME]
      #p ret_exam_3[:COMPLETTIME]
      #p ret_exam_3[:ENTERTIME]
      #p ret_exam_3[:REPORT]
      

      #get exam 4
      result = client.call(:get_exam_4 , message: { "sChart"=>chart, "sE_Seq"=>eseq, "sSeq"=>seq })
      #p result
      ret=result.to_hash[:get_exam_4_response][:get_exam_4_result]
      ret_exam_4=eval(ret)[0]
      #p ret_exam_4
      #p ret_exam_4[:PACSNO]


      examine[i]=Examine.new
      examine[i].seq=ret_exam_3[:SEQ] if ret_exam_3[:SEQ]!=nil
      examine[i].eseq=ret_exam_3[:E_SEQ] if ret_exam_3[:E_SEQ]!=nil
      examine[i].typeid=ret_exam_3[:TYPE] if ret_exam_3[:TYPE]!=nil
      examine[i].typename=ret_exam_3[:TYPE_NAM] if ret_exam_3[:TYPE_NAM]!=nil
      examine[i].source=ret_exam_3[:SOURCE] if ret_exam_3[:SOURCE]!=nil
      examine[i].stat=ret_exam_3[:STAT] if ret_exam_3[:STAT]!=nil
      examine[i].statname=ret_exam_3[:STATNAME] if ret_exam_3[:STATNAME]!=nil
      examine[i].chargdate=ret_exam_2[:CHARGS].to_time.strftime("%F") if ret_exam_2[:CHARGS]!=nil
      examine[i].chargtime=ret_exam_2[:CHARGS].to_time.strftime("%T") if ret_exam_2[:CHARGS]!=nil
      examine[i].logindate=ret_exam_3[:LOGINTIME].to_time.strftime("%F") if ret_exam_3[:LOGINTIME]!=nil
      examine[i].logintime=ret_exam_3[:LOGINTIME].to_time.strftime("%T") if ret_exam_3[:LOGINTIME]!=nil
      examine[i].orderdr=ret_exam_3[:ORDERDR] if ret_exam_3[:ORDERDR]!=nil
      examine[i].orderdrname=ret_exam_3[:ORDERDRNAME] if ret_exam_3[:ORDERDRNAME]!=nil
      examine[i].studydr=ret_exam_3[:STUDYDR] if ret_exam_3[:STUDYDR]!=nil
      examine[i].studydrname=ret_exam_3[:STUDYDRNAME] if ret_exam_3[:STUDYDRNAME]!=nil
      examine[i].enterdr=ret_exam_3[:ENTERDR] if ret_exam_3[:ENTERDR]!=nil
      examine[i].enterdrname=ret_exam_3[:ENTERDRNAME] if ret_exam_3[:ENTERDRNAME]!=nil
      examine[i].orderdate=ret_exam_3[:ORDERTIME].to_time.strftime("%F") if ret_exam_3[:ORDERTIME]!=nil
      examine[i].ordertime=ret_exam_3[:ORDERTIME].to_time.strftime("%T") if ret_exam_3[:ORDERTIME]!=nil
      examine[i].completedate=ret_exam_3[:COMPLETTIME].to_time.strftime("%F") if ret_exam_3[:COMPLETTIME]!=nil
      examine[i].completetime=ret_exam_3[:COMPLETTIME].to_time.strftime("%T") if ret_exam_3[:COMPLETTIME]!=nil
      examine[i].enterdate=ret_exam_3[:ENTERTIME].to_time.strftime("%F") if ret_exam_3[:ENTERTIME]!=nil
      examine[i].entertime=ret_exam_3[:ENTERTIME].to_time.strftime("%T") if ret_exam_3[:ENTERTIME]!=nil
      examine[i].report=ret_exam_3[:REPORT] if ret_exam_3[:REPORT]!=nil
      examine[i].pacsno=ret_exam_4[:pacsno] if ret_exam_4[:pacsno]!=nil
    }


    #sort by login date and login time to get most near now examine. @xieyinghua
    examine=examine.sort_by {|k| [k[:logindate],k[:logintime]] }.reverse

    #only save the most near now examine. @xieyinghua
    examine[0].save


    p "***** examine #{examine[0].seq} inserted."
    examine[0].seq
  end
end
