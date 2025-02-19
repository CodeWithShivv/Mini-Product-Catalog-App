import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/core/router/app_router.dart';
import 'package:mini_product_catalog_app/core/widgets/lottie_loader.dart';
import 'package:mini_product_catalog_app/features/splash/bloc/splash_bloc.dart';
import 'package:mini_product_catalog_app/features/splash/bloc/splash_event.dart';
import 'package:mini_product_catalog_app/features/splash/bloc/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashSuccess) {
          appRouter.go('/products-listing-screen');
        } else if (state is SplashFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            if (state is SplashLoading) {
              return _buildLoadingView();
            } else if (state is SplashFailure) {
              return _buildErrorView(context, state.error);
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: LottieLoader(width: 150, height: 150),
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<SplashBloc>().add(AppInitialized());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
