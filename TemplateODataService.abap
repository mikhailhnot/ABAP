* Template for OData web services

*=============== READ entity
* OData URI template: 
*      /sap/opu/odata/sap/<ServiceName>/<EntutyName>(<keyPropertyName1>=<keyValue1>,<keyPropertyName2>=<keyValue2>,...)  
* HTTP method  GET
*------------
*------------  ...DPC_EXT  method
*        Method parameters
*@78\QImporting@	IV_ENTITY_NAME	TYPE STRING	
*@78\QImporting@	IV_ENTITY_SET_NAME	TYPE STRING	
*@78\QImporting@	IV_SOURCE_NAME	TYPE STRING	
*@78\QImporting@	IT_KEY_TAB	TYPE /IWBEP/T_MGW_NAME_VALUE_PAIR	table for name value pairs
*@78\QImporting@	IO_REQUEST_OBJECT	TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY OPTIONAL	table of navigation paths
*@78\QImporting@	IO_TECH_REQUEST_CONTEXT	TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY OPTIONAL	
*@78\QImporting@	IT_NAVIGATION_PATH	TYPE /IWBEP/T_MGW_NAVIGATION_PATH	table of navigation paths
*@79\QExporting@	ER_ENTITY	TYPE ZCL_ZWM_FIORI_MPC=>TS_USERPARAMS	Returning data
*@79\QExporting@	ES_RESPONSE_CONTEXT	TYPE /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT	
*@03\QException@	/IWBEP/CX_MGW_BUSI_EXCEPTION		business exception in mgw
*@03\QException@	/IWBEP/CX_MGW_TECH_EXCEPTION		mgw technical exception
*===============
METHOD <EntityName>set_get_entity.

    CONSTANTS lc_keyname_1 TYPE string VALUE '<keyPropertyName1>'.
	CONSTANTS lc_keyname_2 TYPE string VALUE '<keyPropertyName2>'.
	  .....
	  
    DATA lv_key_1 TYPE <keyType1>.
    DATA lv_key_2 TYPE <keyType2>.
	  .....
	  
    TRY.
*------   get key values from URI	
        lv_key_1 = it_key_tab[ name = lc_keyname_1 ]-value.
        lv_key_2 = it_key_tab[ name = lc_keyname_2 ]-value.
		    .....
*------   call 	GET method from assistence class		
        zcl_<ServiceName>_assist=><GetEntityMethod>(  EXPORTING  i_<key_1> = lv_key_1
                                                                 i_<key_2> = lv_key_2
			                                                            .....
                                                      IMPORTING  es_result  = er_entity  et_return  = DATA(lt_return) ).  "type BAPIRET2_TTY

      CATCH cx_sy_itab_line_not_found. "INTO DATA(lo_exc). 
        APPEND VALUE #(
           type        = zcl_zwm_fiori_assist=>co_mess_type_erro
           id          = zcl_zwm_fiori_assist=>co_mess_class
           number      = '901'
*           message_v1  = lc_keyname_1
                      ) TO lt_return[].
    ENDTRY.

*-----   save returned messages to service log
    me->/iwbep/if_sb_dpc_comm_services~rfc_save_log( EXPORTING it_return = lt_return[] ).
	
ENDMETHOD.	



*=============== Qeury entity
* OData URI template: 
*      /sap/opu/odata/sap/<ServiceName>/<EntutyName>Set$filter=<FilterCriteria>  
* HTTP method  GET	
*------------
*------------  ...DPC_EXT  method
*        Method parameters
*@78\QImporting@	IV_ENTITY_NAME	TYPE STRING	
*@78\QImporting@	IV_ENTITY_SET_NAME	TYPE STRING	
*@78\QImporting@	IV_SOURCE_NAME	TYPE STRING	
*@78\QImporting@	IT_FILTER_SELECT_OPTIONS	TYPE /IWBEP/T_MGW_SELECT_OPTION	Table of select options
*@78\QImporting@	IS_PAGING	TYPE /IWBEP/S_MGW_PAGING	Paging structure
*@78\QImporting@	IT_KEY_TAB	TYPE /IWBEP/T_MGW_NAME_VALUE_PAIR	Table for name value pairsVitaminV
*@78\QImporting@	IT_NAVIGATION_PATH	TYPE /IWBEP/T_MGW_NAVIGATION_PATH	Table of navigation paths
*@78\QImporting@	IT_ORDER	TYPE /IWBEP/T_MGW_SORTING_ORDER	The sorting order
*@78\QImporting@	IV_FILTER_STRING	TYPE STRING	Table for name value pairs
*@78\QImporting@	IV_SEARCH_STRING	TYPE STRING	
*@78\QImporting@	IO_TECH_REQUEST_CONTEXT	TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET OPTIONAL	
*@79\QExporting@	ET_ENTITYSET	TYPE ZCL_ZWM_FIORI_MPC=>TT_DLHEADER	Returning data
*@79\QExporting@	ES_RESPONSE_CONTEXT	TYPE /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT	
*@03\QException@	/IWBEP/CX_MGW_BUSI_EXCEPTION		business exception in mgw
*@03\QException@	/IWBEP/CX_MGW_TECH_EXCEPTION		mgw technical exception
*===============
METHOD <EntityName>set_get_entityset.	
*-------  call assistant method
    zcl_zwm_fiori_assist=><GetEntitySetMethod>( EXPORTING io_tech_request_context   = io_tech_request_context
                                                          is_paging                 = is_paging
                                                IMPORTING et_return = DATA(lt_return) et_result = et_entityset[] ).
*------- Save log
    me->/iwbep/if_sb_dpc_comm_services~rfc_save_log( EXPORTING it_return = lt_return[] ).

ENDMETHOD
