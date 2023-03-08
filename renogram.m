ant_info=dicominfo("drsprg_114_ANT.dcm");
post_info=dicominfo("drsprg_114_POST.dcm");

pixel_size=ant_info.PixelSpacing;
date=ant_info.ContentDate;
time=ant_info.StudyTime;
manuf=ant_info.Manufacturer;
num_of_frames=ant_info.NumberOfFrames;
radioisotope=ant_info.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideCodeSequence.Item_1.CodeMeaning;
low_energy=ant_info.EnergyWindowInformationSequence.Item_1.EnergyWindowRangeSequence.Item_1.EnergyWindowLowerLimit;
high_energy=ant_info.EnergyWindowInformationSequence.Item_1.EnergyWindowRangeSequence.Item_1.EnergyWindowUpperLimit;
duration_of_exp=ant_info.PhaseInformationSequence.Item_1.ActualFrameDuration*ant_info.NumberOfFrames;
max_pixel=ant_info.LargestImagePixelValue;

ant_img=dicomread(ant_info);
post_img=dicomread(post_info);

ant_right_mask=im2bw(imread("ant_right_mask.png"));
ant_left_mask=im2bw(imread("ant_left_Mask.png"));
ant_background_mask=im2bw(imread("ant_background_Mask.png"));

post_left_mask=im2bw(imread("post_left_Mask.png"));
post_right_mask=im2bw(imread("post_right_mask.png"));
post_background_mask=im2bw(imread("post_background_Mask.png"));

ant_right_activity_curve=zeros(180,1);
ant_left_activity_curve=zeros(180,1);
ant_cor_background=zeros(180,1);


post_right_activity_curve=zeros(180,1);
post_left_activity_curve=zeros(180,1);
post_cor_background=zeros(180,1);


for i=1:180
    ant_cor_background(i)=sum(sum(uint16(ant_background_mask).*ant_img(:,:,:,i)));
    ant_right_activity_curve(i)=sum(sum(uint16(ant_right_mask).*ant_img(:,:,:,i)));
    ant_left_activity_curve(i)=sum(sum(uint16(ant_left_mask).*ant_img(:,:,:,i)));
    cor_ant_right_activity_curve(i)=sum(sum(uint16(ant_right_mask).*ant_img(:,:,:,i)))-ant_cor_background(i);
    cor_ant_left_activity_curve(i)=sum(sum(uint16(ant_left_mask).*ant_img(:,:,:,i)))-ant_cor_background(i);

    post_cor_background(i)=sum(sum(uint16(post_background_mask).*post_img(:,:,:,i)));
    post_right_activity_curve(i)=sum(sum(uint16(post_right_mask).*post_img(:,:,:,i)));
    post_left_activity_curve(i)=sum(sum(uint16(post_left_mask).*post_img(:,:,:,i)));
    cor_post_right_activity_curve(i)=sum(sum(uint16(post_right_mask).*post_img(:,:,:,i)))-post_cor_background(i);
    cor_post_left_activity_curve(i)=sum(sum(uint16(post_left_mask).*post_img(:,:,:,i)))-post_cor_background(i);

end

hold on
legend
title("Without Background Correction")
plot(ant_right_activity_curve,"DisplayName","Left kidney: Anterior")
plot(ant_left_activity_curve,"DisplayName","Right kidney: Anterior")
plot(post_left_activity_curve,"DisplayName","Left kidney: Posterior")
plot(post_right_activity_curve,"DisplayName","Right kidney: Posterior")

figure();
hold on
legend
title("Background Corrected")
plot(cor_ant_right_activity_curve,"DisplayName","Left kidney: Anterior")
plot(cor_ant_left_activity_curve,"DisplayName","Right kidney: Anterior")
plot(cor_post_left_activity_curve,"DisplayName","Left kidney: Posterior")
plot(cor_post_right_activity_curve,"DisplayName","Right kidney: Posterior")