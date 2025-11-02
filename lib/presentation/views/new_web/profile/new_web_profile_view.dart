import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebProfileView extends StatelessWidget {
  const NewWebProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: const QiratHeaderWidget(showShadow: true),
        body: Center(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLogged) {
                return Text('Hi, ${state.user.firstName}',
                    style: const TextStyle(fontFamily: 'Inter'));
              }
              return const Text('Not signed in',
                  style: TextStyle(fontFamily: 'Inter'));
            },
          ),
        ),
      ),
    );
  }
}
