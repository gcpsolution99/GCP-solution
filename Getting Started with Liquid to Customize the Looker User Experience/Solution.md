# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

#### ⚠️ Disclaimer :
- **This script is for the educational purposes just to show how quickly we can solve lab. Please make sure that you have a thorough understanding of the instructions before utilizing any scripts. We do not promote cheating or  misuse of resources. Our objective is to assist you in mastering the labs with efficiency, while also adhering to both 'qwiklabs' terms of services and YouTube's community guidelines.**

### Replace below code in `user` view file

```
view: users {
  sql_table_name: `cloud-training-demos.looker_ecomm.users`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_link {
    type: string
    sql: ${TABLE}.city ;;
    link: {
      label: "Search the web"
      url: "http://www.google.com/search?q={{ value | url_encode }}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | url_encode }}.com"
    }
  }

  dimension: order_history_button {
    label: "Order History"
    sql: ${TABLE}.id ;;
    html: <a href="/explore/training_ecommerce/order_items?fields=order_items.order_item_id, users.first_name, users.last_name, users.id, order_items.order_item_count, order_items.total_revenue&f[users.id]={{ value }}"><button>Order History</button></a> ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }
  
  dimension: state_link {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    html: {% if _explore._name == "order_items" %}
          <a href="/explore/training_ecommerce/order_items?fields=order_items.detail*&f[users.state]= {{ value }}">{{ value }}</a>
        {% else %}
          <a href="/explore/training_ecommerce/users?fields=users.detail*&f[users.state]={{ value }}">{{ value }}</a>
        {% endif %} ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }
}

```

### Replace below code in `order_items` file

```
view: order_items {
    sql_table_name: `cloud-training-demos.looker_ecomm.order_items`
      ;;
    drill_fields: [order_item_id]
  
    dimension: order_item_id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }
  
    dimension_group: created {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.created_at ;;
    }
  
    dimension_group: delivered {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.delivered_at ;;
    }
  
    dimension: inventory_item_id {
      type: number
      # hidden: yes
      sql: ${TABLE}.inventory_item_id ;;
    }
  
    dimension: order_id {
      type: number
      sql: ${TABLE}.order_id ;;
    }
  
    dimension_group: returned {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.returned_at ;;
    }
  
    dimension: sale_price {
      type: number
      sql: ${TABLE}.sale_price ;;
    }
  
    dimension_group: shipped {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.shipped_at ;;
    }
  
    dimension: status {
      type: string
      sql: ${TABLE}.status ;;
    }
  
    dimension: user_id {
      type: number
      # hidden: yes
      sql: ${TABLE}.user_id ;;
    }
  
  
    measure: average_sale_price {
      type: average
      sql: ${sale_price} ;;
      drill_fields: [detail*]
      value_format_name: usd_0
    }
  
    measure: order_item_count {
      type: count
      drill_fields: [detail*]
    }
  
    measure: order_count {
      type: count_distinct
      sql: ${order_id} ;;
    }
  
    measure: total_revenue {
      type: sum
      sql: ${sale_price} ;;
      value_format_name: usd
    }
  
    measure: total_revenue_conditional {
      type: sum
      sql: ${sale_price} ;;
      value_format_name: usd
      html: {% if value > 1300.00 %}
            <p style="color: white; background-color: ##FFC20A; margin: 0; border-radius: 5px; text-align:center">{{ rendered_value }}</p>
            {% elsif value > 1200.00 %}
            <p style="color: white; background-color: #0C7BDC; margin: 0; border-radius: 5px; text-align:center">{{ rendered_value }}</p>
            {% else %}
            <p style="color: white; background-color: #6D7170; margin: 0; border-radius: 5px; text-align:center">{{ rendered_value }}</p>
            {% endif %}
            ;;
    }
  
    measure: total_revenue_from_completed_orders {
      type: sum
      sql: ${sale_price} ;;
      filters: [status: "Complete"]
      value_format_name: usd
    }
  
  
    # ----- Sets of fields for drilling ------
    set: detail {
      fields: [
        order_item_id,
        users.last_name,
        users.id,
        users.first_name,
        inventory_items.id,
        inventory_items.product_name
      ]
    }
  }

```

## ©Credit :
- All rights and credits goes to original content of Google Cloud [Google Cloud SkillBoost](https://www.cloudskillsboost.google/) 

## Congratulations !!

### ** Join us on below platforms **

- <img width="25" alt="image" src="https://github.com/user-attachments/assets/171448df-7b22-4166-8d8d-86f72fb78aff"> [Telegram Discussion Group](https://t.me/+HiOSF3PxrvFhNzU1)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/0ebd7e7d-6f9b-41e9-a241-8483dca9f3f1"> [Telegram Channel](https://t.me/abhiarcadesolution)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/dc326965-d4fa-4f1b-87f1-dbad6e3a7259"> [Abhi Arcade Solution](https://www.youtube.com/@Abhi_Arcade_Solution)
- <img width="26" alt="image" src="https://github.com/user-attachments/assets/d9070a07-7fce-47c5-8626-7ea98ccc46e3"> [WhatsApp](https://whatsapp.com/channel/0029VakEGSJ0VycJcnB8Fn3z)
- <img width="23" alt="image" src="https://github.com/user-attachments/assets/ce0916c3-e5f9-4709-afbd-e67bd42d1c57"> [LinkedIn](https://www.linkedin.com/in/abhi-arcade-solution-9b8a15319/)
