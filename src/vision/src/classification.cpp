#include <ros/package.h>


  std::string path = ros::package::getPath("roslib");
  using package::V_string;
  V_string packages;
  ros::package::getAll(packages);