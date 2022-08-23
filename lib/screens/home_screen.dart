import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../cubit/fatora_cubit.dart';
import '../cubit/fatora_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FatoraCubit()..getAllData(),
      child: BlocConsumer<FatoraCubit, FatoraState>(
          builder: (context, s) {
            return Scaffold(
              appBar: FatoraCubit.get(context).data.isEmpty? null:AppBar(
                actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    backgroundColor: Color(0xFF253341),
                                    title: Text(
                                      'هل تريد حذف الكل ؟!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      MaterialButton(
                                          onPressed: () {
                                            FatoraCubit.get(context)
                                                .deleteAllData()
                                                .then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text(
                                            'نعم',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                          color: Colors.red),
                                      MaterialButton(
                                        onPressed: () {
                                          FatoraCubit.get(context)
                                              .getAllData()
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          'لا',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        color: Colors.green,
                                      )
                                    ],
                                  ),
                                ));
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      iconSize: 35,
                    )
                ],
              ),
              body: FatoraCubit.get(context).data.isEmpty
                  ? Center(
                      child: Text(
                      'لا توجد بيانات !!.. برجاء الضغط على + لاضافة بيانات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold),
                    ))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                              itemBuilder: (_, index) => BuildFatouraItem(
                                    contextCubit: context,
                                    id: FatoraCubit.get(context).data[index]
                                        ['id'],
                                    data: FatoraCubit.get(context).data[index]
                                        ['data'],
                                  ),
                              separatorBuilder: (_, index) => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30.0),
                                    color: Color(0xFF253341),
                                    width: double.infinity,
                                    height: 1,
                                  ),
                              itemCount: FatoraCubit.get(context).data.length),
                        ),
                      ],
                    ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFF253341),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  showMaterialModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (_) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        color: Color(0xFF15202B),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: FatoraCubit.get(context).formKey,
                            child: Center(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    DefaultTextField(
                                      controller:
                                          FatoraCubit.get(context).dataController,

                                      validator: (String? data) {
                                        if (data!.isEmpty) {
                                          return 'لا يجب ان يكون فارغا';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        if (FatoraCubit.get(context)
                                            .formKey
                                            .currentState!
                                            .validate()) {

                                          FatoraCubit.get(context)
                                              .insertToDB(
                                                  data: FatoraCubit.get(context)
                                                      .dataController
                                                      .text)
                                              .then((value) {
                                            FatoraCubit.get(context)
                                                .dataController
                                                .clear();
                                        Navigator.pop(context);
                                          });
                                        }
                                      },
                                      color: Color(0xFF253341),
                                      child: Text(
                                        'اضف',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          listener: (context, s) {}),
    );
  }
}

class DefaultTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType keyboardType;

   DefaultTextField({
    Key? key,
     required this.validator,
    required this.controller,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,
      ),
      maxLines: 5,
      decoration: InputDecoration(
          filled: true,
          fillColor:  Color(0xFF253341),
      ),
    );
  }
}

class BuildFatouraItem extends StatefulWidget {
  const BuildFatouraItem(
      {Key? key,
      required this.data,
      required this.id,
      required this.contextCubit})
      : super(key: key);
  final String data;
  final int id;
  final BuildContext contextCubit;

  @override
  State<BuildFatouraItem> createState() => _BuildFatouraItemState();
}

class _BuildFatouraItemState extends State<BuildFatouraItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        showDialog(
            context: context,
            builder: (_) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    backgroundColor: Color(0xFF253341),
                    title: Text(
                      'هل تريد الحذف ؟',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            FatoraCubit.get(context)
                                .deleteASpecificItem(id: widget.id)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            'نعم',
                            style: TextStyle(fontSize: 30),
                          ),
                          color: Colors.red),
                      MaterialButton(
                        onPressed: () {
                          FatoraCubit.get(context).getAllData().then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'لا',
                          style: TextStyle(fontSize: 30),
                        ),
                        color: Colors.green,
                      )
                    ],
                  ),
                )).then((value) {
          setState(() {});
        });
      },
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color : Color(0xFF253341),
            borderRadius: BorderRadius.circular(15.0)
            
            
          ),
       
          padding: EdgeInsetsDirectional.all(20.0),
          child: Text(
              widget.data,
            style: TextStyle(color: Colors.white, fontSize: 35.0),
          ),
        ),
      ),
    );
  }
}
