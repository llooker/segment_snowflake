# Facts about a particular Session.

view: session_trk_facts {
  derived_table: {
    #sql_trigger_value: select count(*) from ${track_facts.SQL_TABLE_NAME} ;;
    sql: SELECT
    s.session_id
        , MAX(map.timestamp) AS ended_time
        , count(distinct map.event_id) AS num_pvs
        , sum(case when map.event = 'product_viewed' then 1 else null end) as cnt_viewed_product
        , sum(case when map.event = 'product_added' then 1 else null end) as cnt_product_added
        , sum(case when map.event = 'order_completed' then 1 else null end) as cnt_order_completed

      FROM ${sessions_trk.SQL_TABLE_NAME} AS s
      LEFT JOIN ${track_facts.SQL_TABLE_NAME} as map on map.session_id = s.session_id
      GROUP BY 1
       ;;
  }

  dimension: session_id {
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension_group: ended_time {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.ended_time ;;
  }

  dimension: number_events {
    type: number
    sql: ${TABLE}.num_pvs ;;
  }

  dimension: is_bounced_session {
    type: yesno
    sql: ${number_events} = 1 ;;
  }

  dimension: product_viewed {
    type: yesno
    sql: ${TABLE}.cnt_viewed_product > 0 ;;
  }

  dimension: product_added {
    type: yesno
    sql: ${TABLE}.cnt_product_added > 0 ;;
  }

  dimension: order_completed {
    type: yesno
    sql: ${TABLE}.cnt_order_completed > 0 ;;
  }


  dimension: signup {
    type: yesno
    sql: ${TABLE}.cnt_signup > 0 ;;
  }

  measure: count_viewed_product {
    type: count

    filters: {
      field: product_viewed
      value: "yes"
    }
  }

  measure: count_product_added {
    type: count

    filters: {
      field: product_added
      value: "yes"
    }
  }

  measure: count_order_completed {
    type: count

    filters: {
      field: order_completed
      value: "yes"
    }
  }

  measure: count_signup {
    type: count

    filters: {
      field: signup
      value: "yes"
    }
  }


}
