import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ItemDetaisController extends GetxController
{
  RxInt _quantityItem = 1.obs;
  RxInt _sizeItem = 0.obs; 
  RxInt _colorItem = 0.obs; 
  RxBool _isFavourite = false.obs; 

  int get quantity => _quantityItem.value; 
  int get size => _sizeItem.value; 
  int get color => _colorItem.value; 
  bool get isFavourite => _isFavourite.value;

  setQuantityItem(int quantityOfItem){
    _quantityItem.value = quantityOfItem; 
  }

  setSizeItem(int sizeOfItem){
    _sizeItem.value = sizeOfItem; 
  }

  setColorItem(int ColorOfItem){
    _colorItem.value = ColorOfItem; 
  }
  setisFavouriteItem(bool isFavourite){
    _isFavourite.value = isFavourite; 
  }
}