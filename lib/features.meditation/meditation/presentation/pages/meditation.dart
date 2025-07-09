import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mitramanas/core/theme.dart';
import 'package:mitramanas/features.meditation/presentation/widgets/buttons.dart';

import '../bloc/meditation_bloc.dart';
import '../bloc/meditation_state.dart';
import '../widgets/Task_card.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Image.asset('assets/menu_burger.png'),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.png'),
          ),
          SizedBox(width: 16,)
        ],
      ),
      backgroundColor: Colors.white,
      body:BlocBuilder<MeditationBloc,MeditationState>(
        builder: (context,state) {
          if(state is MeditationLoading){
            return Center(child: CircularProgressIndicator());
          }else if(state is DailyQuoteLoaded) {
          return  Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: SingleChildScrollView (
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text('Welcome back',
                          style:Theme.of(context).textTheme.titleLarge
                      ),

                      SizedBox(height: 32,),
                      Text('How are you feeling today ?'
                        ,style: Theme.of(context).textTheme.titleMedium,),
                      SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Button(
                            label:'happy',
                            image:'assets/happy.png',
                            color:Colors.red,
                            onTap: (){},
                          ),
                          Button(
                            label:'Calm',
                            image:'assets/calm.png',
                            color:Colors.lightBlue,
                            onTap: (){},
                          ),
                          Button(
                            label:'Relax',
                            image:'assets/relax.png',
                            color:Colors.orangeAccent,
                            onTap: (){},
                          ),
                          Button(
                            label:'Focus',
                            image:'assets/focus.png',
                            color:Colors.purpleAccent,
                            onTap: (){},

                          ),
                        ],
                      ),
                      SizedBox(height:24),
                      Text('Today\'s Task',
                        style:Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16,),
                      TaskCard(
                        title:'Morning',
                        description:'Let,s open up to the thing that matters among the people',
                        color: DefaultColors.task1,
                        actionText: '',
                      ),
                      SizedBox(height: 16,),
                      TaskCard(
                        title:'Noon',
                        description:'Let,s open up to the thing that matters among the people',
                        color: DefaultColors.task2,
                        actionText: '',
                      ),SizedBox(height: 16,),
                      TaskCard(
                        title:'Evening',
                        description:'Let,s open up to the thing that matters among the people',
                        color: DefaultColors.task3,
                        actionText: '',
                      )
                    ]
                ),
              ),
            );
          }
          else if (state is MoodMessageLoaded){
            showDialog(context: context,
                builder: (context)=>AlertDialog(
                  title: Text('My message for you',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  content: Text(state.moodMessage.text),
                  actions: [
                    TextButton(onPressed: (){Navigator.pop(context);},child: Text('Ok',  style: Theme.of(context).textTheme.labelSmall,)),
                  ],
                )
            );
            return Container();
          }
         else if(state is MeditationError){
            return Center(child: Text(state.message),);
          }else{
            return Center(child: Text('No data found'),);
          }
        },

      ),



    );
  }
}
