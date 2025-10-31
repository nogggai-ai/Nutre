import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../constants/app_constants.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppSizes.paddingSmall,
        mainAxisSpacing: AppSizes.paddingSmall,
      ),
      itemCount: FarmCategories.categories.length,
      itemBuilder: (context, index) {
        final category = FarmCategories.categories[index];
        return CategoryCard(category: category);
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Переход к товарам категории
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Категория: ${category.name}'),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Иконка категории
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(AppColors.primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
              ),
              child: Center(
                child: Text(
                  category.icon ?? '📦',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.paddingSmall),
            
            // Название категории
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
