package be.icteam.demo

import org.apache.spark.sql.SparkSession

object App {

  def main(args: Array[String]): Unit = {

    val spark = SparkSession
      .builder
      .appName("demo")
      .getOrCreate()

    val df = spark.read.csv("/raw/demo/2020/01/14/04/*")
    df.show(10)

    spark.stop()

  }

}
