# Sorting

## [Quick Sort](./src/quick_sort.cairo)

The Quick Sort algorithm is an efficient sorting algorithm used to sort a list of elements. It operates by selecting a 'pivot' element from the array and partitioning the other elements into two sub-arrays, according to whether they are less than or greater than the pivot. The sub-arrays are then recursively sorted.

The purpose of the Quick Sort algorithm is to provide an efficient and practical sorting method. It has an average time complexity of O(n log n), which makes it more efficient for larger lists compared to algorithms like Bubble Sort. However, its worst-case scenario can still reach O(n^2), although this situation is rare, especially if the pivot is chosen wisely.

The time complexity of the Quick Sort algorithm on average is O(n log n), but in the worst-case scenario, it can go up to O(n^2).
The space complexity of the algorithm is O(log n) due to the stack space required for recursion.
The Quick Sort algorithm is considered one of the more efficient sorting algorithms, especially for larger lists. Its efficiency and low space complexity make it a popular choice for many sorting tasks, despite the potential for a high time complexity in the worst-case scenario.

## [Bubble Sort](./src/bubble_sort.cairo)

The bubble sort algorithm is a simple sorting algorithm used to sort a list of elements by repeatedly swapping adjacent elements if they are in the wrong order until the list is sorted.  
The purpose of the bubble sort algorithm is to provide a basic and intuitive sorting method that is easy to understand and implement. While the algorithm has a time complexity of O(n^2), which can make it inefficient for large lists, it is useful for smaller lists and can serve as a starting point for more complex sorting algorithms.

The time complexity of the bubble sort algorithm is O(n^2).  
The space complexity of the algorithm is O(1).  
The bubble sort algorithm is considered one of the least efficient sorting algorithms, especially for larger lists, as its time complexity makes it impractical for large datasets. However, it is still useful in some specific situations where memory usage is a concern.

## [Merge Sort](./src/merge_sort.cairo)

The merge sort algorithm is a sorting algorithm used to sort a list of elements by dividing it into smaller sub-lists, sorting those sub-lists, and then merging them back together.  
The purpose of the merge sort algorithm is to provide a way to efficiently sort large amounts of data. The algorithm has applications in various areas of computer science and data analysis, including database management, information retrieval, and machine learning.  
Additionally, the merge sort algorithm is used in programming and software development, as it is a common example used to teach the concept of divide-and-conquer algorithms. By efficiently sorting large amounts of data, the merge sort algorithm provides a valuable tool for organizing and analyzing information.

The time complexity of the merge sort algorithm is O(n log n).  
The space complexity of the algorithm is O(n).  
The merge sort algorithm is considered one of the most efficient sorting algorithms, as it has a good balance between time and space complexity, and can efficiently handle large amounts of data.
